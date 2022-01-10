package main

import (
	"log"

	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func CreateSessionHandler(app *App) gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		c.Redirect(302, app.AdobeAuth.AuthURL(session))
	}
}

func DeleteSessionHandler(app *App) gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		session.Clear()
		session.Save()
		log.Println("[INFO] logged out")
		c.Redirect(302, "/")
	}
}

func AdobeOAuthCallbackHandler(app *App) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := c.Request.Context()
		session := sessions.Default(c)

		q := c.Request.URL.Query()
		state := q.Get("state")
		if !app.AdobeAuth.IsValidAuthRequest(session, state) {
			log.Printf("[ERROR] state is invalid: %s\n", state)
			c.Redirect(302, "/")
			return
		}
		code := q.Get("code")

		err := app.AdobeAuth.ExchangeToken(ctx, session, code)
		if err != nil {
			log.Printf("[ERROR] %s\n", err.Error())
			c.Redirect(302, "/")
			return
		}
		log.Println("[INFO] logged in")
		c.Redirect(302, "/")
	}
}
