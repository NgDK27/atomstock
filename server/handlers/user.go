package handlers

import (
    "encoding/json"
    "oppenhomies/server/config"
    "oppenhomies/server/models"
    "net/http"
)

func UserInfoHandler(w http.ResponseWriter, r *http.Request) {
    cognitoUserID := r.Context().Value("cognito_user_id").(string)

    var user models.User
    err := config.DB.QueryRow("SELECT id, username, email FROM Users WHERE cognito_user_id = $1", cognitoUserID).Scan(&user.ID, &user.Username, &user.Email)
    if err != nil {
        http.Error(w, "User not found", http.StatusNotFound)
        return
    }

    json.NewEncoder(w).Encode(user)
}
