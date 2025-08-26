package auth

import (
    "crypto/rsa"
    "encoding/base64"
    "encoding/json"
    "fmt"
    "math/big"
    "net/http"
    "strings"
    "sync"
    "time"

    "github.com/gin-gonic/gin"
    "github.com/golang-jwt/jwt/v5"
)

type Middleware struct {
    issuerURL string
    clientID  string
    jwks      *JWKSResponse
    once      sync.Once
    initErr   error
}

type JWKSResponse struct {
    Keys []JWK `json:"keys"`
}

type JWK struct {
    Kid string `json:"kid"`
    Kty string `json:"kty"`
    Use string `json:"use"`
    N   string `json:"n"`
    E   string `json:"e"`
}

func NewAuthMiddleware(cfg Config) *Middleware {
    return &Middleware{
        issuerURL: cfg.IssuerURL,
        clientID:  cfg.ClientID,
    }
}

func (m *Middleware) ensureJWKS() error {
    m.once.Do(func() {
        jwksURL := fmt.Sprintf("%s/protocol/openid-connect/certs", m.issuerURL)
        resp, err := http.Get(jwksURL)
        if err != nil {
            m.initErr = err
            return
        }
        defer resp.Body.Close()

        var jwks JWKSResponse
        if err := json.NewDecoder(resp.Body).Decode(&jwks); err != nil {
            m.initErr = err
            return
        }
        m.jwks = &jwks
    })
    return m.initErr
}

func (m *Middleware) getPublicKey(kid string) (*rsa.PublicKey, error) {
    for _, key := range m.jwks.Keys {
        if key.Kid == kid && key.Kty == "RSA" {
            return m.jwkToRSAPublicKey(key)
        }
    }
    return nil, fmt.Errorf("key not found")
}

func (m *Middleware) jwkToRSAPublicKey(jwk JWK) (*rsa.PublicKey, error) {
    nBytes, err := base64.RawURLEncoding.DecodeString(jwk.N)
    if err != nil {
        return nil, err
    }
    
    eBytes, err := base64.RawURLEncoding.DecodeString(jwk.E)
    if err != nil {
        return nil, err
    }

    n := big.NewInt(0).SetBytes(nBytes)
    e := 0
    for _, b := range eBytes {
        e = e<<8 + int(b)
    }

    return &rsa.PublicKey{N: n, E: e}, nil
}

func (m *Middleware) JWTAuthMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        if err := m.ensureJWKS(); err != nil {
            c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "auth provider not ready"})
            return
        }

        authHeader := c.GetHeader("Authorization")
        if !strings.HasPrefix(authHeader, "Bearer ") {
            c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing or invalid token"})
            return
        }

        rawToken := strings.TrimPrefix(authHeader, "Bearer ")
        
        token, err := jwt.Parse(rawToken, func(token *jwt.Token) (interface{}, error) {
            if _, ok := token.Method.(*jwt.SigningMethodRSA); !ok {
                return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
            }

            kid, ok := token.Header["kid"].(string)
            if !ok {
                return nil, fmt.Errorf("kid not found in token header")
            }

            return m.getPublicKey(kid)
        })

        if err != nil || !token.Valid {
            c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
            return
        }

        if claims, ok := token.Claims.(jwt.MapClaims); ok {
            if exp, ok := claims["exp"].(float64); ok {
                if time.Now().Unix() > int64(exp) {
                    c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "token expired"})
                    return
                }
            }

            if iss, ok := claims["iss"].(string); ok && iss != m.issuerURL {
                c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid issuer"})
                return
            }

            c.Set("user", claims)
        }

        c.Next()
    }
}

func RoleAuthMiddleware(role string) gin.HandlerFunc {
    return func(c *gin.Context) {
        claims, exists := c.Get("user")
        if !exists {
            c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "no user claims"})
            return
        }

        userClaims := claims.(jwt.MapClaims)
        
        realmAccess, ok := userClaims["realm_access"].(map[string]interface{})
        if !ok {
            c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "no realm_access"})
            return
        }

        rolesInterface, ok := realmAccess["roles"].([]interface{})
        if !ok {
            c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "no roles found"})
            return
        }

        hasRole := false
        for _, r := range rolesInterface {
            if roleStr, ok := r.(string); ok && roleStr == role {
                hasRole = true
                break
            }
        }

        if !hasRole {
            c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": "missing role " + role})
            return
        }

        c.Next()
    }
}
