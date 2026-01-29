# Simple CMS - Setup Guide

## 📋 Prerequisites

### Required Tools

- **Docker** (v20.10+)
- **kubectl** (v1.28+)
- **Kind** (v0.20+)
- **Helm** (v3.12+)
- **Git**
- **Node.js** (v18+) - for local development

### Installation Commands

#### macOS (via Homebrew)

```bash
brew install docker kubectl kind helm node
```

#### Linux

```bash
# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/daniel-tsonkov/simple-cms.git
cd simple-cms
```

### 2. Run Setup Script

```bash
chmod +x scripts/*.sh
./scripts/setup-env.sh
```

This script will:

- ✅ Create Kind cluster
- ✅ Install ArgoCD
- ✅ Install Prometheus & Grafana
- ✅ Setup port forwards
- ✅ Display access credentials

### 3. Verify Installation

```bash
# Check cluster
kubectl get nodes

# Check namespaces
kubectl get namespaces

# Check ArgoCD
kubectl get pods -n argocd

# Check Prometheus
kubectl get pods -n monitoring
```

## 🔧 Manual Setup (Alternative)

### Step 1: Create Kind Cluster

```bash
cat <<EOF | kind create cluster --name simple-cms --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
  - containerPort: 443
    hostPort: 443
EOF
```

### Step 2: Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
```

### Step 3: Get ArgoCD Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Step 4: Install Prometheus Stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set grafana.enabled=true \
  --set grafana.adminPassword=admin123
```

### Step 5: Setup Port Forwards

```bash
# ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# Grafana
kubectl port-forward svc/prometheus-grafana -n monitoring 3001:80 &

# Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090 &
```

## 🔐 GitHub Setup

### 1. Create GitOps Repository

```bash
# Create new repository on GitHub: simple-cms-gitops
git clone https://github.com/YOUR_USERNAME/simple-cms-gitops.git
cd simple-cms-gitops

# Copy k8s manifests
mkdir k8s
cp -r ../simple-cms/k8s/* k8s/

git add .
git commit -m "Initial commit"
git push
```

### 2. Configure GitHub Secrets

Go to: Repository Settings → Secrets and variables → Actions

Add the following secrets:

- **GITOPS_PAT**: Personal Access Token with `repo` scope
  - Generate at: https://github.com/settings/tokens

### 3. Update ArgoCD Application

```bash
# Edit argocd/application.yaml
# Replace YOUR_USERNAME with your GitHub username
vim argocd/application.yaml

# Apply to cluster
kubectl apply -f argocd/application.yaml
```

## 🏗️ Infrastructure with Terraform

### 1. Navigate to Terraform Directory

```bash
cd infra/terraform
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan Infrastructure

```bash
terraform plan
```

### 4. Apply Infrastructure

```bash
terraform apply -auto-approve
```

### 5. View Outputs

```bash
terraform output
```

## 🧪 Testing the Pipeline

### 1. Make a Code Change

```bash
cd backend
# Edit server.js or any file
git add .
git commit -m "test: trigger pipeline"
git push origin main
```

### 2. Watch CI/CD Pipeline

- Go to: https://github.com/YOUR_USERNAME/simple-cms/actions
- Watch the workflow run

### 3. Monitor ArgoCD Sync

- Open: https://localhost:8080
- Login with `admin` / `<password>`
- Watch application sync

### 4. Check Application

```bash
# Get frontend service
kubectl get svc -n simple-cms simple-cms-frontend

# If using LoadBalancer (cloud), get external IP
kubectl get svc -n simple-cms simple-cms-frontend -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# For Kind, use port-forward
kubectl port-forward svc/simple-cms-frontend -n simple-cms 8081:80
# Access: http://localhost:8081
```

## 📊 Access Observability

### Grafana

- URL: http://localhost:3001
- Username: `admin`
- Password: `admin123`

Import dashboard:

1. Click "+" → Import
2. Upload `observability/grafana-dashboard.json`
3. Select Prometheus datasource

### Prometheus

- URL: http://localhost:9090
- Query examples:
  - `rate(http_requests_total[5m])`
  - `http_request_duration_seconds_bucket`
  - `up{namespace="simple-cms"}`

### ArgoCD

- URL: https://localhost:8080
- Username: `admin`
- Password: (from setup script output)

## 🧹 Cleanup

### Remove Everything

```bash
./scripts/cleanup-env.sh
```

### Manual Cleanup

```bash
# Delete Kind cluster
kind delete cluster --name simple-cms

# Stop port forwards
pkill -f port-forward
```

## 🐛 Troubleshooting

### ArgoCD Not Syncing

```bash
# Check ArgoCD application
kubectl get applications -n argocd

# Check application status
kubectl describe application simple-cms -n argocd

# Force sync
argocd app sync simple-cms
```

### Pods Not Starting

```bash
# Check pod status
kubectl get pods -n simple-cms

# Describe pod
kubectl describe pod <pod-name> -n simple-cms

# Check logs
kubectl logs <pod-name> -n simple-cms
```

### Port Forward Stopped

```bash
# Kill existing forwards
pkill -f port-forward

# Restart them
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
kubectl port-forward svc/prometheus-grafana -n monitoring 3001:80 &
```

### Image Pull Errors

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Make images public
# Go to: https://github.com/users/YOUR_USERNAME/packages
# Click on package → Settings → Change visibility to Public
```

## 📚 Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Kind Documentation](https://kind.sigs.k8s.io/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
