package main

import (
	"context"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"regexp"
	"strings"

	"golang.org/x/oauth2"
)

type AdobeAPIClient struct {
	Config *oauth2.Config
	Token  *oauth2.Token
}

func (c *AdobeAPIClient) LightroomAPI() *AdobeLightroomAPI {
	return NewAdobeLightroomAPI(c)
}

func (c *AdobeAPIClient) Request(ctx context.Context, req *http.Request) (*http.Response, error) {
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-API-Key", c.Config.ClientID)
	c.Token.SetAuthHeader(req)
	DumpRequest(req)

	client := c.Config.Client(ctx, c.Token)
	res, err := client.Do(req)
	if err != nil {
		return res, err
	}
	DumpResponse(res)
	return res, nil
}

func (c *AdobeAPIClient) DecodeJsonResponse(res *http.Response) (*json.Decoder, error) {
	body, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		return nil, err
	}
	reg := regexp.MustCompile(`^while\s*\(\s*1\s*\)\s*{\s*}\s*`)
	jsonStr := reg.ReplaceAllString(string(body), "")
	DumpJSON(jsonStr)
	decoder := json.NewDecoder(strings.NewReader(jsonStr))
	return decoder, nil
}
