package auth

import (
    "bytes"
    "encoding/json"
    "fmt"
    "io"
    "net/http"
    "net/url"
    "strings"

    "github.com/GoLogann/karhub-beer/domain"
)

type KeycloakClient struct {
    BaseURL   string
    Realm     string
    ClientID  string
    Secret    string
    AdminUser string
    AdminPass string
}

func NewKeycloakClient() *KeycloakClient {
    return &KeycloakClient{
        BaseURL:   "http://localhost:8080",
        Realm:     "karhub-beer",
        ClientID:  "karhub-beer-api",
        Secret:    "CHANGE_ME_IF_CONFIDENTIAL",
        AdminUser: "admin",
        AdminPass: "admin",
    }
}

func (kc *KeycloakClient) getAdminToken() (string, error) {
    data := url.Values{}
    data.Set("client_id", "admin-cli")
    data.Set("username", kc.AdminUser)
    data.Set("password", kc.AdminPass)
    data.Set("grant_type", "password")

    resp, err := http.PostForm(fmt.Sprintf("%s/realms/master/protocol/openid-connect/token", kc.BaseURL), data)
    if err != nil {
        return "", err
    }
    defer resp.Body.Close()

    var result map[string]interface{}
    if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
        return "", err
    }

    token, ok := result["access_token"].(string)
    if !ok {
        return "", fmt.Errorf("failed to obtain admin token: %v", result)
    }
    return token, nil
}

func (kc *KeycloakClient) CreateUser(u domain.User) error {
    token, err := kc.getAdminToken()
    if err != nil {
        return err
    }

    userPayload := map[string]interface{}{
        "username":        u.Username,
        "email":           u.Email,
        "firstName":       u.Username,
        "lastName":        u.Username,
        "enabled":         true,
        "emailVerified":   true,
        "requiredActions": []string{},
    }

    body, _ := json.Marshal(userPayload)

    req, _ := http.NewRequest("POST",
        fmt.Sprintf("%s/admin/realms/%s/users", kc.BaseURL, kc.Realm),
        bytes.NewBuffer(body))
    req.Header.Set("Content-Type", "application/json")
    req.Header.Set("Authorization", "Bearer "+token)

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        return err
    }
    defer resp.Body.Close()

    if resp.StatusCode != 201 {
        b, _ := io.ReadAll(resp.Body)
        return fmt.Errorf("failed to create user: %s", string(b))
    }

    location := resp.Header.Get("Location")
    if location == "" {
        return fmt.Errorf("user created but no Location header returned")
    }
    parts := strings.Split(location, "/")
    userID := parts[len(parts)-1]

    passPayload := map[string]interface{}{
        "type":      "password",
        "value":     u.Password,
        "temporary": false,
    }
    passBody, _ := json.Marshal(passPayload)

    req2, _ := http.NewRequest("PUT",
        fmt.Sprintf("%s/admin/realms/%s/users/%s/reset-password", kc.BaseURL, kc.Realm, userID),
        bytes.NewBuffer(passBody))
    req2.Header.Set("Content-Type", "application/json")
    req2.Header.Set("Authorization", "Bearer "+token)

    resp2, err := client.Do(req2)
    if err != nil {
        return err
    }
    defer resp2.Body.Close()

    if resp2.StatusCode != 204 {
        b, _ := io.ReadAll(resp2.Body)
        return fmt.Errorf("failed to set password: %s", string(b))
    }

    if len(u.Roles) > 0 {
        if err := kc.assignRoles(userID, u.Roles, token); err != nil {
            return fmt.Errorf("user created but failed to assign roles: %w", err)
        }
    }

    return nil
}

func (kc *KeycloakClient) assignRoles(userID string, roles []string, token string) error {
    client := &http.Client{}

    for _, role := range roles {
        req, _ := http.NewRequest("GET",
            fmt.Sprintf("%s/admin/realms/%s/roles/%s", kc.BaseURL, kc.Realm, role),
            nil)
        req.Header.Set("Authorization", "Bearer "+token)

        resp, err := client.Do(req)
        if err != nil {
            return err
        }
        defer resp.Body.Close()

        if resp.StatusCode != 200 {
            b, _ := io.ReadAll(resp.Body)
            return fmt.Errorf("failed to fetch role %s: %s", role, string(b))
        }

        var roleObj map[string]interface{}
        if err := json.NewDecoder(resp.Body).Decode(&roleObj); err != nil {
            return err
        }

        body, _ := json.Marshal([]map[string]interface{}{{
            "id":   roleObj["id"],
            "name": roleObj["name"],
        }})

        req2, _ := http.NewRequest("POST",
            fmt.Sprintf("%s/admin/realms/%s/users/%s/role-mappings/realm", kc.BaseURL, kc.Realm, userID),
            bytes.NewBuffer(body))
        req2.Header.Set("Content-Type", "application/json")
        req2.Header.Set("Authorization", "Bearer "+token)

        resp2, err := client.Do(req2)
        if err != nil {
            return err
        }
        defer resp2.Body.Close()

        if resp2.StatusCode != 204 {
            b, _ := io.ReadAll(resp2.Body)
            return fmt.Errorf("failed to assign role %s: %s", role, string(b))
        }
    }

    return nil
}

func (kc *KeycloakClient) Login(username, password string) (map[string]interface{}, error) {
    data := url.Values{}
    data.Set("client_id", kc.ClientID)
    data.Set("grant_type", "password")
    data.Set("username", username)
    data.Set("password", password)

    resp, err := http.PostForm(fmt.Sprintf("%s/realms/%s/protocol/openid-connect/token", kc.BaseURL, kc.Realm), data)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    var result map[string]interface{}
    if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
        return nil, err
    }

    if resp.StatusCode != 200 {
        return nil, fmt.Errorf("failed to login: %v", result)
    }

    return result, nil
}
