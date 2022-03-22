# Clip pet-api

En este repositorio encontrarás el código y scripts necesarios para desplegar una API con acceso a una base de datos.

En el directorio **infra** se encuentra el código de Terraform para desplegar una VPC de AWS con con una RDS (usando MySQL) y una EC2. Para esta parte de la infraestructura, se puede acceder a la EC2 vía SSH y la RDS únicamente es accesible por medio de la instancia EC2.

En el directorio **database** está un pequeño esquema que nos permite crear una base de datos con una tabla básica.

Finalmente el directorio **api** se encuentra el código necesario para crear una API con un único endpoint que consulta la base de datos “pets”.

## Ejecución

### Prerrequisitos:

- Un *key_pair* para EC2 de AWS y su archivo *pem* generado, guardado en local.
1. Después de clonar este repositorio, desde el directorio principal que contiene a *create_infra.sh* y *deploy_api.sh*, ejecutar:

```bash
$ bash create_infra.sh "key-name"
```

1. Una vez que termine de crearse la infraestructura, verá como salida 3 variables que nos servirán para configurar el despliegue de nuestra aplicación. Ejemplo:

```bash
db-address = "pets.c2spannraqzy.us-west-2.rds.amazonaws.com"
ec2-public-dns = "ec2-34-215-181-199.us-west-2.compute.amazonaws.com"
ec2-public-private-ip = "192.168.1.249"
```

1. Ejecute el script para desplegar la aplicación y pase como parámetros el archivo *pem* (que puede ser de extesión .cer) y  las variables anteriores:

```bash
$ bash deploy_api.sh "key-name.cer" "pets.c2spannraqzy.us-west-2.rds.amazonaws.com" "ec2-34-215-181-199.us-west-2.compute.amazonaws.com" "192.168.1.249"
```

En caso de que haya un error, por favor ejecute estos comandos uno por uno, sustituyendo las variables donde se indica con corchetes:

```bash
scp -i [key-name] ~/net_config.json "ubuntu@[ec2-public-dns]:~/net_config.json"
ssh -i [key-name] "ubuntu@[ec2-public-dns]"
	wget https://dl.google.com/go/go1.17.7.linux-amd64.tar.gz
  sudo tar -xvf go1.17.7.linux-amd64.tar.gz
  sudo mv go /usr/local
  export GOROOT=/usr/local/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
  go env

  git clone https://github.com/kaarla/clip-exercise.git
  cd clip-exercise
  mysql -h [db-address] -u root --password=my-secret-pw < database/pets_schema.sql
  cd api/cmd/petsapi
  go build
  ./petsapi [ec2-public-private-ip] [db-address] &
```

1. Sabrá que la API se está ejecutando correctamente porque el script se ejecutó sin errores **o**  al ejecutar el binario de la API (el último comando), no hay mensajes de error. Por ejemplo, así  se ejecutaría la API:

    `$ ./petsapi "192.168.1.249" "[pets.c2spannraqzy.us-west-2.rds.amazonaws.com](http://pets.c2spannraqzy.us-west-2.rds.amazonaws.com/)" &`

    y una vez que no se reciban errores, desde esta misma terminal u otra con la conexión a ssh hacia nuestra instancia EC2, podríamos hacer una consulta de la siguiente forma:



    ```bash
    $ curl [ec2-public-private-ip]:8080/api/pet/{name}
    ```

    los nombre válidos en la base de datos son:

    - olivia
    - napo
    - korea
    - eli

    y la respuesta esperada es:
    
```json
{
	"name":"eli",
	"owner":"kar",
	"species":"cat",
	"sex":"M"
}
```
