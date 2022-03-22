package main

import (
	"log"
	"net/http"
	"os"

  "api/pkg/server"
)

func main() {
	app_host := os.Args[1]
	server.DB_host = os.Args[2]
  s := server.New()
	log.Fatal(http.ListenAndServe(app_host + ":8080", s.Router()))
}
