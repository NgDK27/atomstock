package main

import (
    "context"
    "crypto/hmac"
    "crypto/sha256"
    "encoding/base64"
    "encoding/json"
    "log"
    "net/http"
    "github.com/aws/aws-sdk-go-v2/aws"
    "github.com/aws/aws-sdk-go-v2/config"
    "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
    "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types"
    "github.com/dgrijalva/jwt-go"
)

var (
    cognitoClient *cognitoidentityprovider.Client
    userPoolID    string = "ap-southeast-2_0GJrd6Rml"
    clientID      string = "736c2cmffhkecljvhq204e8tsq"
    clientSecret  string = "dvt35f9hdm70kggvq2qkq0mfqqvk69n2v1nrm7tovqlnsf8r5l9"
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
    UserID       string `json:"user_id"`
    Message      string `json:"message"`
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

func helloWorldHandler(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "text/plain")
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("Hello World"))
}

func signupHandler(w http.ResponseWriter, r *http.Request) {
    var input SignUpInput
    err := json.NewDecoder(r.Body).Decode(&input)
    if err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    secretHash := calculateSecretHash(clientID, clientSecret, input.Email)

    _, err = cognitoClient.SignUp(context.TODO(), &cognitoidentityprovider.SignUpInput{
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
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    response := SignUpResponse{Message: "Please check your email for the OTP to confirm your account."}
    json.NewEncoder(w).Encode(response)
}

type ConfirmSignUpInput struct {
    Email string `json:"email"`
    OTP   string `json:"otp"`
}

type ConfirmSignUpResponse struct {
    Message string `json:"message"`
}

func confirmSignUpHandler(w http.ResponseWriter, r *http.Request) {
    var input ConfirmSignUpInput
    err := json.NewDecoder(r.Body).Decode(&input)
    if err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    secretHash := calculateSecretHash(clientID, clientSecret, input.Email)

    _, err = cognitoClient.ConfirmSignUp(context.TODO(), &cognitoidentityprovider.ConfirmSignUpInput{
        ClientId:         aws.String(clientID),
        Username:         aws.String(input.Email),
        ConfirmationCode: aws.String(input.OTP),
        SecretHash:       aws.String(secretHash),
    })

    if err != nil {
        log.Printf("Failed to confirm sign up: %v", err)
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    response := ConfirmSignUpResponse{Message: "Signup confirmed! Your account has been created."}
    json.NewEncoder(w).Encode(response)
}

func signInHandler(w http.ResponseWriter, r *http.Request) {
    var input SignInInput
    err := json.NewDecoder(r.Body).Decode(&input)
    if err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
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
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    accessToken := *authOutput.AuthenticationResult.AccessToken
    userID, err := extractUserIDFromToken(accessToken)
    if err != nil {
        log.Printf("Failed to extract user ID from token: %v", err)
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    response := SignInResponse{
        AccessToken:  accessToken,
        IdToken:      *authOutput.AuthenticationResult.IdToken,
        RefreshToken: *authOutput.AuthenticationResult.RefreshToken,
        UserID:       userID,
        Message:      "Sign-in successful!",
    }
    json.NewEncoder(w).Encode(response)
}


func main() {
    cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion("ap-southeast-2"))
    if err != nil {
        log.Fatalf("unable to load SDK config, %v", err)
    }

    cognitoClient = cognitoidentityprovider.NewFromConfig(cfg)

    http.HandleFunc("/", helloWorldHandler)
    http.HandleFunc("/signup", signupHandler)
    http.HandleFunc("/confirm_signup", confirmSignUpHandler)
    http.HandleFunc("/signin", signInHandler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
