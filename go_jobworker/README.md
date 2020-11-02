# Go jobworker

## Dependencies

* Go: 1.14.x
- Docker: >= 18.06
- docker-compose: >= 1.25.0

## Setup

```sh
#------------------------------------------------------------------------------
# 1. Install `docker`, `docker-compose`
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 2. Setup
#------------------------------------------------------------------------------
docker-compose up
```

## Usage

```sh
# Enqueue jobs
docker-compose exec worker go run cmd/client/main.go

# Open dashboard
open http://localhost:5000

# Show framegraph
docker-compose exec worker go-torch -u http://127.0.0.1:6060 -p > torch.svg
open torch.svg
```
