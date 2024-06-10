package main

import (
    "log"
    "net/http"
    "oppenhomies/server/config"
    "oppenhomies/server/handlers"
    "oppenhomies/server/middlewares"

    "github.com/gorilla/mux"
)

func main() {
    config.LoadConfig()

    r := mux.NewRouter()

    r.HandleFunc("/signup", handlers.SignUpHandler).Methods("POST")
    r.HandleFunc("/confirm", handlers.ConfirmSignUpHandler).Methods("POST")
    r.HandleFunc("/login", handlers.LoginHandler).Methods("POST")
    r.HandleFunc("/google-login", handlers.GoogleLoginHandler).Methods("GET")
    r.HandleFunc("/google-callback", handlers.GoogleCallbackHandler).Methods("GET")

    api := r.PathPrefix("/api").Subrouter()
    api.Use(middleware.AuthenticationMiddleware)
    api.HandleFunc("/userinfo", handlers.UserInfoHandler).Methods("GET")

    log.Println("Server running on port 8000")
    log.Fatal(http.ListenAndServe(":8000", r))
}
