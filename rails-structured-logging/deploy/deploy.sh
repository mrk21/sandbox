#!/bin/bash -eu
cd $(dirname $0)

. ./setup.sh

# Build image
echo "=== Build image ================================================================"
set -x
docker-compose -f docker-compose.build.yml build
set +x
echo ""

# Push image
echo "=== Push image ================================================================="
set -x
ecs-cli push ${APP_IMAGE}
set +x
echo ""

# Get created services
CREATED_SERVICES=$(aws ecs list-services --cluster ${CLUSTER})
SERVICE_EXISTED=$(echo ${CREATED_SERVICES} | grep ${SERVICE} | wc -l | sed -E 's/ +//g')

echo "=== Created services ==========================================================="
echo ${CREATED_SERVICES}
echo ""

if [ ${SERVICE_EXISTED} -eq 0 ]; then
  # Create service
  echo "=== Create service ============================================================="
  ecs-cli-compose service create \
    --launch-type EC2 \
    --target-group-arn ${TARGET_GROUP_ARN} \
    --container-name app \
    --container-port 3000
  echo ""

  echo "=== Run migration task ========================================================="
  ecs-cli-compose run app ./docker/app/migration.sh
  echo ""

  echo "=== Set service scale =========================================================="
  ecs-cli-compose service scale 2 \
    --deployment-max-percent 200 \
    --deployment-min-healthy-percent 50 \
    --timeout 10
  echo ""
else
  # Update service
  echo "=== Run migration task ========================================================="
  ecs-cli-compose run app ./docker/app/migration.sh
  echo ""

  echo "=== Update service ============================================================="
  ecs-cli-compose service up --timeout 10 --force-deployment
  echo ""
fi
