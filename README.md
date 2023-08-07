# tegola-buildpack

> Tegola server Scalingo buildpack

This buildpack downloads and installs [Tegola](https://tegola.io) into a Scalingo app image.

## Configuration

The buildpack is expecting a configuration file at the root of the project
which is `config.toml`.

## Usage

The following instructions should get you started:

1. Initialize a new git repository wherever you want:

```bash
% mkdir my-tegola
% cd my-tegola
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
% scalingo --app my-tegola env-set BUILDPACK_URL="https://github.com/tristanrobert/tegola-buildpack.git#main"
% scalingo --app my-tegola env-set TEGOLA_VERSION="0.17.0" #(optional because default is 0.17.0)
% scalingo --app my-tegola env-set DB_URI="$SCALINGO_POSTGRESQL_URL" #db uri to postgresql addon connection
% scalingo --app my-tegola env-set CORS_ALLOW_ORIGIN="*" #default *, you can restrict origins to your custom domain
```
