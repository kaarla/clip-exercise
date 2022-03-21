FROM golang:alpine

WORKDIR /api
COPY . .
RUN go mod tidy
WORKDIR /api/cmd/petsapi
RUN echo $(pwd)
RUN go build
RUN echo $(ls)
CMD ["/api/cmd/petsapi/petsapi"]
EXPOSE 8080
