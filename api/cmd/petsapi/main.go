package main

import (
	"log"
	"net/http"

  "api/pkg/server"
)

func main() {
  s := server.New()
	log.Fatal(http.ListenAndServe("172.0.0.2:8080", s.Router()))
}
