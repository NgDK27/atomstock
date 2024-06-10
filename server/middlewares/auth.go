package middleware

import (
    "context"
    "oppenhomies/server/config"
    "oppenhomies/server/utils"
    "net/http"
    "strings"
)

func AuthenticationMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        authHeader := r.Header.Get("Authorization")
        if authHeader == "" {
            http.Error(w, "Missing Authorization Header", http.StatusUnauthorized)
            return
        }

        tokenString := strings.TrimPrefix(authHeader, "Bearer ")

        claims, err := utils.ParseJWT(tokenString, config.JwtSecret)
        if err != nil {
            http.Error(w, err.Error(), http.StatusUnauthorized)
            return
        }

        cognitoUserID := claims["sub"].(string)
        ctx := context.WithValue(r.Context(), "cognito_user_id", cognitoUserID)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}
