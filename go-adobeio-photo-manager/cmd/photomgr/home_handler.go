package main

import (
	"log"

	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func HomeHandler(app *App) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := c.Request.Context()
		session := sessions.Default(c)
		client := app.AdobeAuth.GetClient(ctx, session)

		if client == nil {
			c.HTML(200, "index.html.tmpl", gin.H{})
			return
		}
		lightroom := client.LightroomAPI()

		catalog, _, err := lightroom.GetCatalog(ctx)
		if err != nil {
			log.Println("[ERROR]", err.Error())
			c.Data(500, "text/html", []byte("error"))
			return
		}
		if catalog == nil {
			c.Data(500, "text/html", []byte("error"))
			return
		}

		assetList, _, err := lightroom.GetAssetList(ctx, GetAssetListParams{
			CatalogId: catalog.Id,
			Limit:     10,
		})
		if err != nil {
			log.Println("[ERROR]", err.Error())
			c.Data(500, "text/html", []byte("error"))
			return
		}
		if assetList == nil {
			c.Data(500, "text/html", []byte("error"))
			return
		}

		c.HTML(200, "home.html.tmpl", gin.H{
			"Catalog": catalog,
			"Assets":  assetList.Resources,
		})
	}
}
