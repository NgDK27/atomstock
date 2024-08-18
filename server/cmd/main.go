package main

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"database/sql"
	"encoding/base64"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"reflect"
	"os/signal"
    "syscall"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types"
	"github.com/golang-jwt/jwt/v5"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/redis/go-redis/v9"
    "oppenhomies/server/internal/handlers"
	_ "github.com/lib/pq"
)

var (
	cognitoClient *cognitoidentityprovider.Client
	clientID      string 
	clientSecret  string 
	db            *sql.DB
)

type SignUpInput struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type SignUpResponse struct {
	Message string `json:"message"`
}

type SignInInput struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type SignInResponse struct {
	AccessToken  string `json:"access_token"`
	IdToken      string `json:"id_token"`
	RefreshToken string `json:"refresh_token"`
	Message      string `json:"message"`
}

type ConfirmSignUpInput struct {
	Email string `json:"email"`
	OTP   string `json:"otp"`
}

type ConfirmSignUpResponse struct {
	Message string `json:"message"`
}

type UpdateBalanceInput struct {
	Amount string  `json:"amount"`
}

func calculateSecretHash(clientID, clientSecret, username string) string {
	mac := hmac.New(sha256.New, []byte(clientSecret))
	mac.Write([]byte(username + clientID))
	return base64.StdEncoding.EncodeToString(mac.Sum(nil))
}

func extractUserIDFromToken(tokenString string) (string, error) {
	token, _, err := new(jwt.Parser).ParseUnverified(tokenString, jwt.MapClaims{})
	if err != nil {
		return "", err
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok {
		if sub, ok := claims["sub"].(string); ok {
			return sub, nil
		}
	}

	return "", nil
}

func helloWorldHandler(c *gin.Context) {
	c.String(http.StatusOK, "Hello World")
}

func signupHandler(c *gin.Context) {
	var input SignUpInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	secretHash := calculateSecretHash(clientID, clientSecret, input.Email)

	_, err := cognitoClient.SignUp(context.TODO(), &cognitoidentityprovider.SignUpInput{
		ClientId:   aws.String(clientID),
		Username:   aws.String(input.Email),
		Password:   aws.String(input.Password),
		SecretHash: aws.String(secretHash),
		UserAttributes: []types.AttributeType{
			{
				Name:  aws.String("email"),
				Value: aws.String(input.Email),
			},
		},
	})

	if err != nil {
		log.Printf("Failed to sign up: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	response := SignUpResponse{Message: "Please check your email for the OTP to confirm your account."}
	c.JSON(http.StatusOK, response)
}

func confirmSignUpHandler(c *gin.Context) {
	var input ConfirmSignUpInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	secretHash := calculateSecretHash(clientID, clientSecret, input.Email)

	_, err := cognitoClient.ConfirmSignUp(context.TODO(), &cognitoidentityprovider.ConfirmSignUpInput{
		ClientId:         aws.String(clientID),
		Username:         aws.String(input.Email),
		ConfirmationCode: aws.String(input.OTP),
		SecretHash:       aws.String(secretHash),
	})

	if err != nil {
		log.Printf("Failed to confirm sign up: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	response := ConfirmSignUpResponse{Message: "Signup confirmed! Your account has been created."}
	c.JSON(http.StatusOK, response)
}

func signInHandler(c *gin.Context) {
	var input SignInInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	secretHash := calculateSecretHash(clientID, clientSecret, input.Email)

	authParams := map[string]string{
		"USERNAME":    input.Email,
		"PASSWORD":    input.Password,
		"SECRET_HASH": secretHash,
	}

	authInput := &cognitoidentityprovider.InitiateAuthInput{
		AuthFlow:       types.AuthFlowTypeUserPasswordAuth,
		ClientId:       aws.String(clientID),
		AuthParameters: authParams,
	}

	authOutput, err := cognitoClient.InitiateAuth(context.TODO(), authInput)
	if err != nil {
		log.Printf("Failed to sign in: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	accessToken := *authOutput.AuthenticationResult.AccessToken
	userID, err := extractUserIDFromToken(accessToken)
	if err != nil {
		log.Printf("Failed to extract user ID from token: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Check if user exists in PostgreSQL
	var email string
	err = db.QueryRow("SELECT email FROM users WHERE id = $1", userID).Scan(&email)
	if err == sql.ErrNoRows {
		// User does not exist, create user
		_, err = db.Exec("INSERT INTO users (id, email) VALUES ($1, $2)", userID, input.Email)
		if err != nil {
			log.Printf("Failed to create user: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
			return
		}
		_, err = db.Exec("INSERT INTO portfolios (user_id) VALUES ($1)", userID)
		if err != nil {
			log.Printf("Failed to create portfolio: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user's portfolio"})
			return
		}
	} else if err != nil {
		log.Printf("Failed to query user: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query user"})
		return
	}

	response := SignInResponse{
		AccessToken:  accessToken,
		IdToken:      *authOutput.AuthenticationResult.IdToken,
		RefreshToken: *authOutput.AuthenticationResult.RefreshToken,
		Message:      "Sign-in successful!",
	}
	c.JSON(http.StatusOK, response)
}

func depositHandler(c *gin.Context) {
	var input UpdateBalanceInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	amount, err := strconv.ParseFloat(input.Amount, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid amount"})
		return
	}

	tokenString := c.GetHeader("Authorization")
	tokenString = strings.TrimPrefix(tokenString, "Bearer ")
	userID, err := extractUserIDFromToken(tokenString)
	fmt.Println(reflect.TypeOf(amount))
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
		return
	}

	_, err = db.Exec("UPDATE users SET balance = balance + $1 WHERE id = $2", amount, userID)
	if err != nil {
		log.Printf("Failed to deposit for user %s: %v", userID, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to deposit"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Balance updated successfully"})
}

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString := c.GetHeader("Authorization")
		if tokenString == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "No token provided"})
			c.Abort()
			return
		}

		tokenString = strings.TrimPrefix(tokenString, "Bearer ")

		_, err := extractUserIDFromToken(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		c.Next()
	}
}

func ConnectDatabase() {
	
	host := os.Getenv("HOST")
	port, _ := strconv.Atoi(os.Getenv("PORT"))
	user := os.Getenv("USER")
	dbname := os.Getenv("DB_NAME")
	pass := os.Getenv("PASSWORD")

	psqlSetup := fmt.Sprintf("host=%s port=%d user=%s dbname=%s password=%s sslmode=disable",
		host, port, user, dbname, pass)
	database, err := sql.Open("postgres", psqlSetup)
	if err != nil {
		fmt.Println("Error while connecting to the database:", err)
		panic(err)
	} else {
		db = database
		fmt.Println("Successfully connected to the database!")
	}
}

func main() {
	godotenv.Load() 
	
	ConnectDatabase()

	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion("ap-southeast-2"))
	if err != nil {
		log.Fatalf("Unable to load SDK config, %v", err)
	}

	cognitoClient = cognitoidentityprovider.NewFromConfig(cfg)
    clientID = os.Getenv("clientID")
    clientSecret = os.Getenv("clientSecret")

	redisClient := redis.NewClient(&redis.Options{
        Addr: os.Getenv("REDIS_ADDR"),
    })

	if err := redisClient.Ping(context.Background()).Err(); err != nil {
        log.Fatalf("Failed to connect to Redis: %v", err)
    }
    log.Println("Successfully connected to Redis")
	

	r := gin.Default()

	r.POST("/signup", signupHandler)
	r.POST("/confirm_signup", confirmSignUpHandler)
	r.POST("/signin", signInHandler)

	// Market data endpoints
    r.GET("/main-market", handlers.GetMainMarketData(redisClient))
    r.GET("/ws/main-market", handlers.MainMarketWebSocket(redisClient))
    
    // Stock detail endpoints
    r.GET("/stock/:symbol", handlers.GetStockDetail(redisClient))
    r.GET("/ws/stock/:symbol", handlers.StockDetailWebSocket(redisClient))
    
    // Index detail endpoints
    r.GET("/index/:indexId", handlers.GetIndexDetail(redisClient))
    r.GET("/ws/index/:indexId", handlers.IndexDetailWebSocket(redisClient))
    
    // Search endpoint
    // r.GET("/search", handlers.SearchStocks(redisClient))

	protected := r.Group("/")
	protected.Use(AuthMiddleware())
	protected.GET("/hello", helloWorldHandler)
	protected.POST("/deposit", depositHandler) 

	go func() {
        if err := r.Run(":8080"); err != nil {
            log.Fatalf("Failed to start server: %v", err)
        }
    }()

    // Set up shutdown
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit

    log.Println("Shutting down server...")

    log.Println("Server exited")
}
