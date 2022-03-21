package server

import (
  "fmt"
  "encoding/json"
  "log"
  "net/http"

  "github.com/gorilla/mux"
  pet "api/pkg"

  "database/sql"
    _ "github.com/go-sql-driver/mysql"
)

type api struct {
	router http.Handler
}

type Server interface {
	Router() http.Handler
}

func New() Server {
	a := &api{}

	r := mux.NewRouter()
  r.HandleFunc("/api/pet/{name:[a-zA-Z]+}", a.fetchPet).Methods(http.MethodGet)

	a.router = r
	return a
}

func (a *api) Router() http.Handler {
	return a.router
}

func (a *api) fetchPet(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
  name, ok := vars["name"]

  if !ok {
    log.Println("Url Param 'name' is missing")
    return
  }
  log.Println("URL param is", name)

	var pet pet.Pet

  db, err := sql.Open("mysql", "root:my-secret-pw@tcp(127.0.0.1:3306)/pets")
  if err != nil {
        panic(err.Error())
  }
  log.Print("Connection to database: Success")

  query := fmt.Sprintf("SELECT * FROM Pet WHERE name='%s'", name)
  errQ := db.QueryRow(query).Scan(&pet.Name, &pet.Owner, &pet.Species, &pet.Sex)
  defer db.Close()

  w.Header().Set("Content-Type", "application/json")
  if errQ != nil {
    w.WriteHeader(http.StatusNotFound) 
		json.NewEncoder(w).Encode("Pet Not found")
		return
  }
  log.Println("result:", pet)

	json.NewEncoder(w).Encode(pet)
}
