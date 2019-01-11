# AWS ECS Rails

Rails on ECS sample

## Middlewares/Tools

- Ruby: 2.6.0
- Rails: 5.2.2
- MySQL: 8.0
- Node.js
- Nginx

### for Development

- direnv
- Docker

## Services

- AWS
  - VPC
  - EC2
  - ECS
  - RDS
  - ALB
  - Route 53

## Setup

```bash
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .
cp .env.sample .env
vi .env
docker-compose build
docker-compose run app bundle
docker-compose run app rails db:setup
docker-compose up
open http://localhost:${DOCKER_HOST_APP_PORT}/
```

## Build Docker image for production

### Rails

```bash
$(aws ecr get-login --no-include-email --region ap-northeast-1)
docker build -t aws-ecs-rails-app -f docker/rails/Dockerfile.prod .
docker tag aws-ecs-rails-app:latest ${DOCKER_REPO_APP}:latest
docker push ${DOCKER_REPO_APP}:latest
```

### Nginx

```bash
$(aws ecr get-login --no-include-email --region ap-northeast-1)
docker build -t aws-ecs-rails-nginx -f docker/nginx/Dockerfile.prod .
docker tag aws-ecs-rails-nginx:latest ${DOCKER_REPO_NGINX}:latest
docker push ${DOCKER_REPO_NGINX}:latest
```

## More documentation

- [ECSメモ](https://mrk21.kibe.la/shared/entries/a6e41cea-1960-43ac-a88a-014ed2493fc7)
