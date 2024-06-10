package config

import (
    "database/sql"
    "log"
    "os"

    "github.com/aws/aws-sdk-go-v2/config"
    "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
    "context"
    _ "github.com/lib/pq"
)

var (
    DB             *sql.DB
    CognitoClient  *cognitoidentityprovider.Client
    ClientID       string
    ClientSecret   string
    UserPoolID     string
    GoogleClientID string
    GoogleSecret   string
    JwtSecret      []byte
)

func LoadConfig() {
    var err error

    DB, err = sql.Open("postgres", os.Getenv("DATABASE_URL"))

    if err != nil {
        log.Fatalf("Failed to connect to database: %v", err)
    }

    cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion("ap-southeast-2"))
    if err != nil {
        log.Fatalf("Failed to load AWS config: %v", err)
    }

    CognitoClient = cognitoidentityprovider.NewFromConfig(cfg)
    ClientID = os.Getenv("COGNITO_CLIENT_ID")
    ClientSecret = os.Getenv("COGNITO_CLIENT_SECRET")
    UserPoolID = os.Getenv("COGNITO_USER_POOL_ID")
    GoogleClientID = os.Getenv("GOOGLE_CLIENT_ID")
    GoogleSecret = os.Getenv("GOOGLE_CLIENT_SECRET")
    JwtSecret = []byte(os.Getenv("JWT_SECRET"))
}
