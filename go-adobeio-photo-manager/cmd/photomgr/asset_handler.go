package main

import (
	"io/ioutil"
	"log"

	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func AssetDetailHandler(app *App) gin.HandlerFunc {
	return func(c *gin.Context) {
		catalogId, _ := c.Params.Get("catalog_id")
		assetId, _ := c.Params.Get("asset_id")

		c.HTML(200, "asset.html.tmpl", gin.H{
			"CatalogId": catalogId,
			"AssetId":   assetId,
		})
	}
}

func AssetImageHandler(app *App) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := c.Request.Context()
		session := sessions.Default(c)
		catalogId, _ := c.Params.Get("catalog_id")
		assetId, _ := c.Params.Get("asset_id")
		imgType, _ := c.Params.Get("type")

		client := app.AdobeAuth.GetClient(ctx, session)
		if client == nil {
			c.Data(403, "image/png", []byte(""))
			return
		}
		lightroom := client.LightroomAPI()

		res, err := lightroom.GetAssetRendition(ctx, GetAssetRenditionParams{
			CatalogId:     catalogId,
			AssetId:       assetId,
			RenditionType: imgType,
		})
		if err != nil {
			log.Println("[ERROR]", err.Error())
			c.Data(400, "image/png", []byte(""))
			return
		}
		if res.StatusCode >= 400 {
			c.Data(400, "image/png", []byte(""))
			return
		}
		contentType := res.Header.Get("Content-Type")
		data, _ := ioutil.ReadAll(res.Body)
		res.Body.Close()
		c.Data(200, contentType, data)
	}
}
