# go-config

## dependencies

- Go: 1.21
- [gopkg.in/yaml.v3](https://github.com/go-yaml/yaml)
- [dario.cat/mergo](https://github.com/darccio/mergo)

## Setup

```sh
docker compose build
docker compose up
```

## Usage

```sh
# Boot
docker compose up

# Open devcontainer
devcontainer open .

# Make single binary
docker compose exec app make

# Run config command
docker compose exec app go run ./cmd/config/

# Run config command(single binary)
docker compose exec app config
```
