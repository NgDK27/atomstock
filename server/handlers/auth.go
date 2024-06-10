package handlers

import (
    "context"
    "encoding/json"
    "oppenhomies/server/config"
    "net/http"

    "github.com/aws/aws-sdk-go-v2/aws"
    "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
    "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types"
    "golang.org/x/oauth2"
    "golang.org/x/oauth2/google"
)

var googleOauthConfig = &oauth2.Config{
    RedirectURL:  "http://localhost:8000/google-callback",
    ClientID:     config.GoogleClientID,
    ClientSecret: config.GoogleSecret,
    Scopes: []string{
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/userinfo.profile",
    },
    Endpoint: google.Endpoint,
}

type SignUpInput struct {
    Username string `json:"username"`
    Email    string `json:"email"`
    Password string `json:"password"`
}

func SignUpHandler(w http.ResponseWriter, r *http.Request) {
    var input SignUpInput
    if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    _, err := config.CognitoClient.SignUp(context.TODO(), &cognitoidentityprovider.SignUpInput{
        ClientId: aws.String(config.ClientID),
        Username: aws.String(input.Username),
        Password: aws.String(input.Password),
        UserAttributes: []types.AttributeType{
            {
                Name:  aws.String("email"),
                Value: aws.String(input.Email),
            },
        },
    })
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    w.WriteHeader(http.StatusOK)
}

type ConfirmSignUpInput struct {
    Username string `json:"username"`
    Code     string `json:"code"`
}

func ConfirmSignUpHandler(w http.ResponseWriter, r *http.Request) {
    var input ConfirmSignUpInput
    if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    _, err := config.CognitoClient.ConfirmSignUp(context.TODO(), &cognitoidentityprovider.ConfirmSignUpInput{
        ClientId:         aws.String(config.ClientID),
        Username:         aws.String(input.Username),
        ConfirmationCode: aws.String(input.Code),
    })
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    w.WriteHeader(http.StatusOK)
}

type LoginInput struct {
    Username string `json:"username"`
    Password string `json:"password"`
}

func LoginHandler(w http.ResponseWriter, r *http.Request) {
    var input LoginInput
    if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    authInput := &cognitoidentityprovider.InitiateAuthInput{
        AuthFlow: types.AuthFlowTypeUserPasswordAuth,
        AuthParameters: map[string]string{
            "USERNAME": input.Username,
            "PASSWORD": input.Password,
        },
        ClientId: aws.String(config.ClientID),
    }

    authResp, err := config.CognitoClient.InitiateAuth(context.TODO(), authInput)
    if err != nil {
        http.Error(w, "Failed to authenticate", http.StatusUnauthorized)
        return
    }

    idToken := *authResp.AuthenticationResult.IdToken
    accessToken := *authResp.AuthenticationResult.AccessToken

    json.NewEncoder(w).Encode(map[string]string{
        "id_token":      idToken,
        "access_token": accessToken,
    })
}

func GoogleLoginHandler(w http.ResponseWriter, r *http.Request) {
    url := googleOauthConfig.AuthCodeURL("state")
    http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func GoogleCallbackHandler(w http.ResponseWriter, r *http.Request) {
    code := r.URL.Query().Get("code")
    token, err := googleOauthConfig.Exchange(context.TODO(), code)
    if err != nil {
        http.Error(w, "Failed to exchange token", http.StatusInternalServerError)
        return
    }

    // Use token to fetch user info
    client := googleOauthConfig.Client(context.Background(), token)
    response, err := client.Get("https://www.googleapis.com/oauth2/v2/userinfo")
    if err != nil {
        http.Error(w, "Failed to fetch user info", http.StatusInternalServerError)
        return
    }
    defer response.Body.Close()

    var userInfo struct {
        Id    string `json:"id"`
        Email string `json:"email"`
    }
    if err := json.NewDecoder(response.Body).Decode(&userInfo); err != nil {
        http.Error(w, "Failed to decode user info", http.StatusInternalServerError)
        return
    }

    // Verify user and create in Cognito if necessary
    // Ensure your user pool allows for federated identities
    _, err = config.CognitoClient.AdminGetUser(context.TODO(), &cognitoidentityprovider.AdminGetUserInput{
        UserPoolId: aws.String(config.UserPoolID),
        Username:   aws.String(userInfo.Email),
    })

    if err != nil {
        // Create new user
        _, err := config.CognitoClient.AdminCreateUser(context.TODO(), &cognitoidentityprovider.AdminCreateUserInput{
            UserPoolId: aws.String(config.UserPoolID),
            Username:   aws.String(userInfo.Email),
            UserAttributes: []types.AttributeType{
                {
                    Name:  aws.String("email"),
                    Value: aws.String(userInfo.Email),
                },
                {
                    Name:  aws.String("email_verified"),
                    Value: aws.String("true"),
                },
            },
        })
        if err != nil {
            http.Error(w, "Failed to create user", http.StatusInternalServerError)
            return
        }
    }

    // Retrieve tokens for the user
    authInput := &cognitoidentityprovider.InitiateAuthInput{
        AuthFlow: types.AuthFlowTypeCustomAuth,
        AuthParameters: map[string]string{
            "USERNAME": userInfo.Email,
        },
        ClientId: aws.String(config.ClientID),
    }

    authResp, err := config.CognitoClient.InitiateAuth(context.TODO(), authInput)
    if err != nil {
        http.Error(w, "Failed to authenticate", http.StatusUnauthorized)
        return
    }

    idToken := *authResp.AuthenticationResult.IdToken
    accessToken := *authResp.AuthenticationResult.AccessToken

    json.NewEncoder(w).Encode(map[string]string{
        "id_token":      idToken,
        "access_token": accessToken,
    })
}
