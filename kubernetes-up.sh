#!/bin/bash

# Set your DockerHub username
DOCKER_USER="bunyakorngoko"

# Define image names
FRONTEND_IMAGE="mern-app-frontend"
BACKEND_IMAGE="mern-app-backend"

# Build Docker images
echo "🚀 Building Docker images..."
docker build -t $BACKEND_IMAGE ./backend
docker build -t $FRONTEND_IMAGE ./frontend

# Tag images for Docker Hub
echo "🏷️ Tagging images..."
docker tag $FRONTEND_IMAGE $DOCKER_USER/$FRONTEND_IMAGE:latest
docker tag $BACKEND_IMAGE $DOCKER_USER/$BACKEND_IMAGE:latest

# Push images to Docker Hub
echo "📤 Pushing images to Docker Hub..."
docker push $DOCKER_USER/$FRONTEND_IMAGE:latest
docker push $DOCKER_USER/$BACKEND_IMAGE:latest

# Change directory to Kubernetes manifests (modify if needed)
cd kubernetes || exit

# Delete old deployments and pods
echo "🗑️ Deleting old Kubernetes resources..."
kubectl delete deployment backend frontend --ignore-not-found
kubectl delete pod --all --ignore-not-found

# Apply Kubernetes configurations
echo "🚀 Deploying new Kubernetes resources..."
kubectl apply -f backend-deployment.yml
kubectl apply -f frontend-deployment.yml
kubectl apply -f mongo-deployment.yml

# Show deployment status
echo "📌 Getting pod and service status..."
kubectl get pods
kubectl get services

echo "✅ Deployment complete!"
