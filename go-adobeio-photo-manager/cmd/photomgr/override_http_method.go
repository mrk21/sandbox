package main

import (
	"strings"

	"github.com/gin-gonic/gin"
)

// Override HTTP method by `_method` POST body parameter. It's for HTML forms.
// @see [bu/gin-method-override: MethodOverride middleware for Gin web framework](https://github.com/bu/gin-method-override)
func OverrideHttpMethodMiddleware(r *gin.Engine) gin.HandlerFunc {
	return func(c *gin.Context) {
		if c.Request.Method != "POST" {
			c.Next()
			return
		}
		method := strings.ToUpper(c.PostForm("_method"))
		switch method {
		case "PUT", "PATCH", "DELETE":
			c.Request.Method = method
			c.Abort()
			r.HandleContext(c)
		default:
			c.Next()
		}
	}
}
