## Deploying A01-MLOPS to Minikube (Step-by-Step, Windows-friendly)

This guide explains how to deploy the Flask API in this repo to Minikube, end-to-end. It includes building the image, loading it into Minikube, applying Kubernetes manifests, enabling Ingress, and verifying with test data. Commands are written for Windows PowerShell.

### Prerequisites
- Minikube installed and a working hypervisor (e.g., Docker, Hyper-V). See `https://minikube.sigs.k8s.io/docs/start/`.
- kubectl installed and on PATH. See `https://kubernetes.io/docs/tasks/tools/`.
- Docker installed if you prefer building locally. Alternatively, use `minikube image build`.
- This repository cloned locally.

### Repository Overview for Deployment
- Dockerfile runs the Flask app on port 5000.
- Kubernetes manifests in `k8s/`:
  - `deployment.yaml` - runs a single replica of the app exposing container port 5000.
  - `service.yaml` - ClusterIP Service on port 80 to the pod's 5000.
  - `ingress.yaml` - Ingress routing `heart.local` to the Service.

### Choose an Image Build Strategy
You can build inside Minikube (recommended for simplicity) or locally and then load into Minikube.

Option A: Build inside Minikube (simple)
```powershell
minikube start
minikube image build -t a01-mlops:local .
```

Option B: Build locally and load into Minikube
```powershell
minikube start
docker build -t a01-mlops:local .
minikube image load a01-mlops:local
```

Both options produce the image tag `a01-mlops:local` which matches the Deployment.

### Deploy the App
```powershell
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

Wait for the pod to be ready:
```powershell
kubectl get pods -l app=heart-api -w
```
When READY shows `1/1`, press Ctrl+C.

### Enable and Configure Ingress
Enable the NGINX ingress addon:
```powershell
minikube addons enable ingress
```

Apply the Ingress manifest:
```powershell
kubectl apply -f k8s/ingress.yaml
```

Point `heart.local` to the Minikube node IP by adding a hosts entry.
Get the Minikube IP:
```powershell
minikube ip
```
Edit hosts as Administrator and add a line like:
```
<MINIKUBE_IP>  heart.local
```
On Windows, edit: `C:\Windows\System32\drivers\etc\hosts`

Verify the Ingress shows an address:
```powershell
kubectl get ingress heart-api
```

### Test the API via Ingress
Root endpoint:
```powershell
curl http://heart.local/
```

Prediction endpoint (POST JSON):
Use provided `test_data_correct.json`:
```powershell
Invoke-WebRequest -Uri http://heart.local/predict -Method POST -ContentType 'application/json' -InFile .\test_data_correct.json | Select-Object -ExpandProperty Content
```

### Troubleshooting
- Check pod logs:
```powershell
kubectl logs deploy/heart-api
```
- Describe resources to see events/errors:
```powershell
kubectl describe deploy/heart-api
kubectl describe svc/heart-api
kubectl describe ingress/heart-api
```
- If image not found, ensure you used `a01-mlops:local` and loaded/built into Minikube.
- If Ingress 404: ensure addon enabled and hosts file updated to Minikube IP.

### Clean Up
```powershell
kubectl delete -f k8s/ingress.yaml
kubectl delete -f k8s/service.yaml
kubectl delete -f k8s/deployment.yaml
```

### Notes
- The Deployment uses readiness and liveness probes on `/` port 5000.
- Service exposes port 80 in-cluster; Ingress routes HTTP traffic from `heart.local` to the Service.

