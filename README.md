# tegola-buildpack

> Tegola server Scalingo buildpack

This buildpack downloads and installs [Tegola](https://tegola.io) into a Scalingo app image.

## Configuration

The buildpack is expecting a configuration file at the root of the project
which is `config.toml`. See [configuration doc](https://tegola.io/documentation/configuration/).

Minimum required config is:

```toml
[webserver]
port = ":$PORT" # PORT is env var given by Scalingo platform

[webserver.headers]
# redefine default cors origin
Access-Control-Allow-Origin = "http://map.example.com"

[[providers]]
name = "test_postgis"       # provider name is referenced from map layers (required)
type = "postgis"            # the type of data provider must be "postgis" for this data provider (required)

uri = "$DB_URI" # DB_URI is PostGIS connection env var (required) given by Scalingo addon
srid = 3857
```

## Usage

The following instructions should get you started:

1. Initialize a new git repository wherever you want:

```bash
% mkdir my-tegola
% cd my-tegola
% cat config.toml # create and set config.toml, see doc
% git init
```

2. Create the Scalingo app:

```bash
% scalingo create my-tegola
% scalingo --app my-tegola scale web:1:M
```

3. Add a PostgreSQL addon:

```bash
% scalingo --app my-tegola addons-add postgresql postgresql-starter-512
```

4. Setup the app environment:

```bash
% scalingo --app my-tegola env-set BUILDPACK_URL="https://github.com/tristanrobert/tegola-buildpack#main"
% scalingo --app my-tegola env-set TEGOLA_VERSION=0.17.0 #(optional because default is 0.17.0)
% scalingo --app my-tegola env-set DB_URI="$SCALINGO_POSTGRESQL_URL" #db uri to postgresql addon connection
% scalingo --app my-tegola env-set CORS_ALLOW_ORIGIN=* #default *, you can restrict origins to your custom domain
```

## Hacking

You set environment variables in `.env`:

```shell
mkdir -p /tmp/{build,cache,env,app}
cp .env.sample /env/.env
```

Run an interactive docker scalingo stack:

```shell
docker run --name tegola -it -p 8080:8080 -v "$(pwd)"/env/.env:/env/.env -v "$(pwd)":/buildpack -v "$(pwd)/build":/build -v "$(pwd)/cache":/cache -v "$(pwd)/app":/app scalingo/scalingo-22:latest bash
```

And test in it step by step:

```shell
bash buildpack/bin/detect /build
bash buildpack/bin/env.sh /env/.env /env
bash buildpack/bin/compile /build /cache /env
cp -a /build/. /app
bash buildpack/bin/release
```

And test full stack in docker compose with postgresql with postgis extension:

```shell
docker-compose up --build -d
docker-compose down -v
```
