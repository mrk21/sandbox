package main

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"

	"github.com/gin-contrib/sessions"
	"golang.org/x/oauth2"
)

type AdobeAuth struct {
	Config *oauth2.Config
}

// OAuth state is used session ID hashed by SHA256, because it protects from CSRF and session hijack.
func (auth *AdobeAuth) AuthState(session sessions.Session) string {
	if session.ID() == "" {
		session.Set("touch", 1)
		session.Save()
	}
	hash := sha256.Sum256([]byte(session.ID()))
	return hex.EncodeToString(hash[:])
}

func (auth *AdobeAuth) AuthURL(session sessions.Session) string {
	state := auth.AuthState(session)
	return auth.Config.AuthCodeURL(state)
}

func (auth *AdobeAuth) IsValidAuthRequest(session sessions.Session, state string) bool {
	expectedState := auth.AuthState(session)
	return state == expectedState
}

func (auth *AdobeAuth) ExchangeToken(ctx context.Context, session sessions.Session, code string) error {
	token, err := auth.Config.Exchange(ctx, code)
	if err != nil {
		return err
	}
	value, err := json.Marshal(token)
	if err != nil {
		return err
	}
	session.Set("adobe-oauth-token", string(value))
	session.Save()
	return nil
}

func (auth *AdobeAuth) GetToken(session sessions.Session) *oauth2.Token {
	value := session.Get("adobe-oauth-token")
	if value == nil {
		return nil
	}
	token := &oauth2.Token{}
	json.Unmarshal([]byte(value.(string)), token)
	return token
}

func (auth *AdobeAuth) GetClient(ctx context.Context, session sessions.Session) *AdobeAPIClient {
	token := auth.GetToken(session)
	if token == nil {
		return nil
	}
	return &AdobeAPIClient{Config: auth.Config, Token: token}
}
