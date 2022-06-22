package main

import (
	"log"

	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"
	"github.com/gin-contrib/sessions/redis"
	"github.com/gin-gonic/gin"
)

func CreateRedisSessionStore() redis.Store {
	store, err := redis.NewStoreWithDB(10, "tcp", "redis:6379", "", "1", []byte("secret"))
	if err != nil {
		log.Fatal(err)
	}
	return store
}

func CreateCookieSessionStore() cookie.Store {
	return cookie.NewStore([]byte("secret"))
}

func SessionMiddleware() gin.HandlerFunc {
	store := CreateRedisSessionStore()
	store.Options(sessions.Options{
		Path:     "/",
		MaxAge:   86400 * 30,
		HttpOnly: true,
		Secure:   true,
	})
	return sessions.Sessions("photo-manager", store)
}
