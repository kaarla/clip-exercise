package pet

type Pet struct {
	Name      string    `json:"name,omitempty"`
	Owner     string    `json:"owner,omitempty"`
	Species   string    `json:"species,omitempty"`
  Sex       string    `json:"sex,omitempty"`
}
