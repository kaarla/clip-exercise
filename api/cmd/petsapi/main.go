package main

import (
	"log"
	"net/http"

  "api/pkg/server"
)

func main() {
  s := server.New()
	log.Fatal(http.ListenAndServe("localhost:8080", s.Router()))
}
