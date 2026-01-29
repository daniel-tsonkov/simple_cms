#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Simple CMS DevOps Environment Setup${NC}"
echo "================================================"

# Check prerequisites
echo -e "\n${YELLOW}📋 Checking prerequisites...${NC}"

command -v docker >/dev/null 2>&1 || { echo -e "${RED}❌ Docker is not installed${NC}"; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo -e "${RED}❌ kubectl is not installed${NC}"; exit 1; }
command -v kind >/dev/null 2>&1 || { echo -e "${RED}❌ Kind is not installed${NC}"; exit 1; }
command -v helm >/dev/null 2>&1 || { echo -e "${RED}❌ Helm is not installed${NC}"; exit 1; }

echo -e "${GREEN}✅ All prerequisites met${NC}"

# Create Kind cluster
echo -e "\n${YELLOW}📦 Creating Kind cluster...${NC}"
if kind get clusters | grep -q "simple-cms"; then
    echo -e "${YELLOW}⚠️  Cluster 'simple-cms' already exists. Skipping...${NC}"
else
    cat <<EOF | kind create cluster --name simple-cms --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
    echo -e "${GREEN}✅ Kind cluster created${NC}"
fi

# Install ArgoCD
echo -e "\n${YELLOW}🔄 Installing ArgoCD...${NC}"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "${YELLOW}⏳ Waiting for ArgoCD to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
echo -e "${GREEN}✅ ArgoCD installed${NC}"

# Install Prometheus Stack
echo -e "\n${YELLOW}📊 Installing Prometheus & Grafana...${NC}"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set grafana.enabled=true \
  --set grafana.adminPassword=admin123 \
  --wait

echo -e "${GREEN}✅ Prometheus & Grafana installed${NC}"

# Get ArgoCD admin password
echo -e "\n${YELLOW}🔑 Retrieving ArgoCD credentials...${NC}"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "${GREEN}ArgoCD Admin Username:${NC} admin"
echo -e "${GREEN}ArgoCD Admin Password:${NC} $ARGOCD_PASSWORD"

# Setup port forwarding (in background)
echo -e "\n${YELLOW}🌐 Setting up port forwards...${NC}"

# Kill any existing port forwards
pkill -f "port-forward.*argocd" || true
pkill -f "port-forward.*grafana" || true
pkill -f "port-forward.*prometheus" || true

# Start new port forwards
nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
nohup kubectl port-forward svc/prometheus-grafana -n monitoring 3001:80 > /dev/null 2>&1 &
nohup kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090 > /dev/null 2>&1 &

sleep 5

echo -e "${GREEN}✅ Port forwards configured${NC}"

# Summary
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Access URLs:${NC}"
echo -e "  🔹 ArgoCD:     ${GREEN}https://localhost:8080${NC}"
echo -e "     Username: ${GREEN}admin${NC}"
echo -e "     Password: ${GREEN}$ARGOCD_PASSWORD${NC}"
echo ""
echo -e "  🔹 Grafana:    ${GREEN}http://localhost:3001${NC}"
echo -e "     Username: ${GREEN}admin${NC}"
echo -e "     Password: ${GREEN}admin123${NC}"
echo ""
echo -e "  🔹 Prometheus: ${GREEN}http://localhost:9090${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Apply ArgoCD application: ${GREEN}kubectl apply -f argocd/application.yaml${NC}"
echo -e "  2. Push code to trigger CI/CD pipeline"
echo -e "  3. Watch deployment in ArgoCD UI"
echo ""
echo -e "${YELLOW}Cleanup:${NC} Run ${GREEN}./scripts/cleanup-env.sh${NC} to remove everything"