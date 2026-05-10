#!/bin/bash

DOCKER_IMAGE="nashit836/abode-webapp"
DOCKER_TAG="latest"
CONTAINER_NAME="abode-webapp"

echo "🚀 Starting Deployment"

# Build
echo "Step 1: Building Docker image..."
docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

# Test
echo "Step 2: Running tests..."
docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash -c "bash /tests/run-tests.sh"

# Deploy
echo "Step 3: Deploying..."
docker stop ${CONTAINER_NAME} 2>/dev/null || true
docker rm ${CONTAINER_NAME} 2>/dev/null || true

docker run -d \
    --name ${CONTAINER_NAME} \
    -p 80:80 \
    ${DOCKER_IMAGE}:${DOCKER_TAG}

echo "Step 4: Health check..."
sleep 10
curl -f http://localhost:80

echo "✅ Deployment Complete!"
echo "Access: http://localhost:80"
