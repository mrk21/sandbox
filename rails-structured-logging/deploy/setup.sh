# Set env
echo "=== Setup ======================================================================"
set -x

export RAILS_ENV=${RAILS_ENV:-staging}
export REVISION=$(git rev-parse --short HEAD)
export REPONAME=$(git remote get-url --push origin | sed -E 's/^[^:]+:([^:.]+)\.git$/\1/g')
export AWS_REGION=${AWS_DEFAULT_REGION}
export IMAGE_VERSION=$(echo ${REPONAME}|sed -e 's/\//-/g').${REVISION}
export IMAGE_BASEURL=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/ecs-test
export APP_IMAGE=${IMAGE_BASEURL}/app:${IMAGE_VERSION}

export COMPOSE_PROJECT_NAME=ecs-test
export CLUSTER=ecs-test
export SERVICE=${COMPOSE_PROJECT_NAME}

export TARGET_GROUP_NAME=ecs-test

export TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --names ${TARGET_GROUP_NAME} | jq -r '.TargetGroups[].TargetGroupArn')

export SUBNET_NAME="ecs-test-*"
export SUBNETS=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAME}" | jq -c '[.Subnets[].SubnetId]')

export SECURITY_GROUP_NAME="ecs-test-app-task"
export SECURITY_GROUPS=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=${SECURITY_GROUP_NAME}" | jq -c '[.SecurityGroups[].GroupId]')

set +x
echo ""

# Define function
function ecs-cli-compose () {
  set -x
  ecs-cli compose \
    --region ${AWS_REGION} \
    --cluster ${CLUSTER} \
    --file docker-compose.yml \
    --ecs-params ecs-params.yml \
    "$@"
  set +x
}
