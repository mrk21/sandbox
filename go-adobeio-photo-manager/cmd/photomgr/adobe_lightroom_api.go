package main

import (
	"context"
	"fmt"
	"net/http"
)

func LightroomApiUrl(apiUri string, params ...interface{}) string {
	return fmt.Sprintf("https://lr.adobe.io"+apiUri, params...)
}

type AdobeLightroomAPI struct {
	Client *AdobeAPIClient
}

func NewAdobeLightroomAPI(client *AdobeAPIClient) *AdobeLightroomAPI {
	return &AdobeLightroomAPI{
		Client: client,
	}
}

// GetCatalog
type Catalog struct {
	Id string `json:"id"`
}

func (c *AdobeLightroomAPI) GetCatalog(ctx context.Context) (*Catalog, *http.Response, error) {
	req, err := http.NewRequest("GET", LightroomApiUrl("/v2/catalog"), nil)
	if err != nil {
		return nil, nil, err
	}

	res, err := c.Client.Request(ctx, req)
	if res.StatusCode != 200 {
		return nil, res, err
	}

	decoder, err := c.Client.DecodeJsonResponse(res)
	if err != nil {
		return nil, nil, err
	}
	catalog := &Catalog{}
	decoder.Decode(catalog)
	return catalog, res, err
}

// GetAssetList
type AssetList struct {
	Resources []Asset `json:"resources"`
}
type Asset struct {
	Id string `json:"id"`
}

type GetAssetListParams struct {
	CatalogId string
	Limit     int
}

func (c *AdobeLightroomAPI) GetAssetList(ctx context.Context, params GetAssetListParams) (*AssetList, *http.Response, error) {
	req, err := http.NewRequest(
		"GET",
		LightroomApiUrl("/v2/catalogs/%s/assets?limit=%d", params.CatalogId, params.Limit),
		nil,
	)
	if err != nil {
		return nil, nil, err
	}

	res, err := c.Client.Request(ctx, req)
	if res.StatusCode != 200 {
		return nil, res, err
	}

	decoder, err := c.Client.DecodeJsonResponse(res)
	if err != nil {
		return nil, nil, err
	}
	assetList := &AssetList{}
	decoder.Decode(assetList)
	return assetList, res, err
}

// GetAssetRendition
type GetAssetRenditionParams struct {
	CatalogId     string
	AssetId       string
	RenditionType string
}

func (c *AdobeLightroomAPI) GetAssetRendition(ctx context.Context, params GetAssetRenditionParams) (*http.Response, error) {
	req, err := http.NewRequest(
		"GET",
		LightroomApiUrl("/v2/catalogs/%s/assets/%s/renditions/%s", params.CatalogId, params.AssetId, params.RenditionType),
		nil,
	)
	if err != nil {
		return nil, err
	}

	return c.Client.Request(ctx, req)
}
