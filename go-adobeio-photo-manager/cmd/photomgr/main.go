package main

import (
	"os"

	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
)

func main() {
	r := gin.New()
	r.Use(OverrideHttpMethodMiddleware(r))
	r.Use(gin.Logger())
	r.Use(gin.Recovery())
	r.Use(SessionMiddleware())
	r.LoadHTMLGlob("cmd/photomgr/*.tmpl")

	app := &App{
		AdobeAuth: &AdobeAuth{
			Config: &oauth2.Config{
				ClientID:     os.Getenv("ADOBE_CLIENT_ID"),
				ClientSecret: os.Getenv("ADOBE_CLIENT_SECRET"),
				Scopes:       []string{"lr_partner_apis", "openid", "AdobeID", "offline_access"},
				RedirectURL:  "https://localhost:8000/auth/adobe/callback",
				Endpoint: oauth2.Endpoint{
					AuthURL:  "https://ims-na1.adobelogin.com/ims/authorize/v2",
					TokenURL: "https://ims-na1.adobelogin.com/ims/token/v3",
				},
			},
		},
	}

	// Home
	r.GET("/", HomeHandler(app))

	// Session
	r.POST("/session", CreateSessionHandler(app))
	r.DELETE("/session", DeleteSessionHandler(app))
	r.GET("/auth/adobe/callback", AdobeOAuthCallbackHandler(app))

	// Asset
	r.GET("/assets/:catalog_id/:asset_id", AssetDetailHandler(app))
	r.GET("/assets/:catalog_id/:asset_id/:type", AssetImageHandler(app))

	r.Run(":8080")
}
