Param(
  [ValidateSet('minikube-build','local-build')]
  [string]$BuildMode = 'minikube-build'
)

Write-Host "Starting Minikube..."
minikube start

if ($BuildMode -eq 'minikube-build') {
  Write-Host "Building image inside Minikube..."
  minikube image build -t a01-mlops:local .
} else {
  Write-Host "Building image locally and loading into Minikube..."
  docker build -t a01-mlops:local .
  minikube image load a01-mlops:local
}

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

Write-Host "Enabling ingress addon..."
minikube addons enable ingress | Out-Null
kubectl apply -f k8s/ingress.yaml

Write-Host "Waiting for pod to be ready..."
kubectl wait --for=condition=ready pod -l app=heart-api --timeout=180s

$ip = (minikube ip)
Write-Host "Minikube IP: $ip"
Write-Host "Add the following to your hosts file as Administrator:"
Write-Host "$ip`t heart.local"

Write-Host "Try: curl http://heart.local/"

