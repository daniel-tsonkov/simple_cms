# 🚀 Simple CMS - Complete DevOps Solution

A full-stack web application with automated software delivery pipeline covering 15+ DevOps topics.

[![CI/CD Pipeline](https://github.com/daniel-tsonkov/simple_cms/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/daniel-tsonkov/simple_cms/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Note**: This is a fork of [daniel-tsonkov/simple_cms](https://github.com/daniel-tsonkov/simple_cms) with DevOps pipeline implementation.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Topics Covered](#topics-covered)
- [Documentation](#documentation)
- [Demo](#demo)
- [Contributing](#contributing)

## 🎯 Overview

Simple CMS is a demonstration project showcasing a complete DevOps pipeline with:

- **Backend**: Node.js + Express
- **Frontend**: Vanilla JavaScript SPA
- **CI/CD**: GitHub Actions
- **GitOps**: ArgoCD
- **Orchestration**: Kubernetes
- **IaC**: Terraform
- **Observability**: Prometheus + Grafana

## ✨ Features

### Application

- ✅ RESTful API with Express
- ✅ SQLite database
- ✅ Health checks & readiness probes
- ✅ Prometheus metrics endpoint
- ✅ Simple web interface

### DevOps Pipeline

- ✅ **Continuous Integration**
  - Automated linting (ESLint)
  - Unit tests (Jest)
  - Secret scanning (TruffleHog)
  - SAST (Semgrep)
  - Code quality checks

- ✅ **Continuous Deployment**
  - Docker image builds
  - Container registry (GHCR)
  - Vulnerability scanning (Trivy)
  - GitOps updates
  - Automated Kubernetes deployments

- ✅ **Infrastructure as Code**
  - Terraform for cluster setup
  - Kubernetes manifests
  - Helm charts for tooling

- ✅ **Observability**
  - Prometheus metrics
  - Grafana dashboards
  - Alert rules
  - Health monitoring

- ✅ **Security**
  - Secret scanning
  - SAST analysis
  - Image vulnerability scanning
  - Non-root containers
  - Resource limits

## 🏗️ Architecture

```
┌─────────────┐
│  Developer  │
└──────┬──────┘
       │ push
       ▼
┌──────────────────────────────────┐
│  GitHub Repository               │
│  daniel-tsonkov/simple_cms            │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────┐
│  GitHub Actions CI   │
│  - Lint & Test       │
│  - Security Scans    │
│  - Build & Push      │
│  - Update GitOps     │
└──────────┬───────────┘
           │
           ▼
┌───────────────────────────────────┐
│   GitOps Repository               │
│   daniel-tsonkov/simple_cms-gitops     │
└──────────┬────────────────────────┘
           │
           ▼
┌──────────────────────┐
│      ArgoCD          │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│    Kubernetes        │
│  ┌──────────────┐    │
│  │  simple_cms  │    │
│  └──────────────┘    │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Observability      │
│  Prometheus+Grafana  │
└──────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Docker
- kubectl
- Kind
- Helm
- Node.js 18+

### Setup

1. **Clone the repository**

```bash
git clone https://github.com/daniel-tsonkov/simple_cms.git
cd simple_cms
```

2. **Run setup script**

```bash
chmod +x scripts/*.sh
./scripts/setup-env.sh
```

3. **Access services**

- ArgoCD: https://localhost:8080
- Grafana: http://localhost:3001
- Prometheus: http://localhost:9090

For detailed setup instructions, see [docs/setup.md](docs/setup.md)

## 📚 Topics Covered

This project demonstrates knowledge in:

1. **SDLC & Methodologies** ✅
2. **Source Control (Git)** ✅
3. **Branching Strategies** ✅
4. **CI/CD Pipelines** ✅
5. **Continuous Integration** ✅
6. **Continuous Deployment** ✅
7. **GitOps** ✅ _(Deep Dive)_
8. **Containerization (Docker)** ✅
9. **Container Orchestration (Kubernetes)** ✅
10. **Infrastructure as Code (Terraform)** ✅
11. **Configuration Management** ✅
12. **Observability** ✅
13. **Monitoring (Prometheus)** ✅
14. **Visualization (Grafana)** ✅
15. **Security Scanning** ✅
16. **SAST** ✅
17. **Secrets Management** ✅
18. **Testing & Quality** ✅
19. **Immutable Infrastructure** ✅
20. **Automation** ✅

## 📖 Documentation

- [Architecture](docs/architecture.md) - Detailed system design
- [Setup Guide](docs/setup.md) - Step-by-step installation
- [Demo Script](docs/demo-script.md) - Presentation guide

## 🎬 Demo

The project includes a complete demo script for presentations:

- High-level architecture overview
- Live CI/CD pipeline execution
- GitOps deployment with ArgoCD
- Real-time observability metrics
- Deep dive into GitOps patterns

See [docs/demo-script.md](docs/demo-script.md) for the full script.

## 🔧 Local Development

### Run Locally with Docker Compose

```bash
docker-compose up -d
```

Access:

- Backend: http://localhost:3000
- Frontend: http://localhost:8080

### Run Backend Locally

```bash
cd backend
npm install
npm run dev
```

### Run Tests

```bash
cd backend
npm test
npm run lint
```

## 🛡️ Security

Security is built into every layer:

- Secret scanning in CI
- SAST for code analysis
- Container vulnerability scanning
- Non-root container users
- Resource limits and quotas
- Network policies (optional)

## 🎯 Future Improvements

- [ ] Canary deployments
- [ ] Blue-Green deployments
- [ ] Service Mesh (Istio)
- [ ] Policy as Code (OPA)
- [ ] Chaos Engineering (Litmus)
- [ ] DAST scanning
- [ ] Multi-cluster setup
- [ ] Database migrations automation

## 📦 Related Repositories

- **Application Repo**: [daniel-tsonkov/simple_cms](https://github.com/daniel-tsonkov/simple_cms)
- **GitOps Repo**: [daniel-tsonkov/simple_cms-gitops](https://github.com/daniel-tsonkov/simple_cms-gitops)
- **Original Repo**: [daniel-tsonkov/simple_cms](https://github.com/daniel-tsonkov/simple_cms)

## 🤝 Contributing

This is an educational project. Feel free to fork and adapt for your own learning!

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details

## 👤 Author

**Mariya Tsonkova**

- GitHub: [@daniel-tsonkov](https://github.com/daniel-tsonkov)
- Original Project: [daniel-tsonkov/simple_cms](https://github.com/daniel-tsonkov/simple_cms)

## 🙏 Acknowledgments

- Daniel Tsonkov for the original Simple CMS application
- Anthropic Claude for DevOps pipeline assistance
- DevOps community for best practices
- Open source tools that make this possible

---

**⭐ If you find this project helpful, please give it a star!**

#!/bin/bash

# Complete Setup Commands for daniel-tsonkov/simple_cms

# ============================================

# STEP 1: Clone Your Repository

# ============================================

git clone https://github.com/daniel-tsonkov/simple_cms.git
cd simple_cms

# ============================================

# STEP 2: Create and Setup GitOps Repository

# ============================================

# On GitHub: Create new repository named "simple_cms-gitops"

# Then run:

cd ..
git clone https://github.com/daniel-tsonkov/simple_cms-gitops.git
cd simple_cms-gitops

# Copy k8s manifests from simple_cms

mkdir k8s
cp ../simple_cms/k8s/\*.yaml k8s/

# Create README for GitOps repo

cat > README.md << 'EOF'

# Simple CMS GitOps Repository

This repository contains the Kubernetes manifests for Simple CMS that are deployed by ArgoCD.

## 📁 Structure

```
k8s/
├── namespace.yaml       - Namespace definition
├── deployment.yaml      - Deployments (updated by CI/CD)
├── service.yaml         - Services
└── servicemonitor.yaml  - Prometheus scraping config
```

## 🔄 Automated Updates

The `deployment.yaml` file is automatically updated by the CI/CD pipeline in the [daniel-tsonkov/simple_cms](https://github.com/daniel-tsonkov/simple_cms) repository when new images are built.

**ArgoCD Application:** See [simple_cms/argocd/application.yaml](https://github.com/daniel-tsonkov/simple_cms/blob/main/argocd/application.yaml)

## ⚠️ Manual Changes

Do not edit manifests directly in this repository unless you know what you're doing. Changes should be made in the [simple_cms repository](https://github.com/daniel-tsonkov/simple_cms) first.
EOF

# Commit and push

git add .
git commit -m "Initial commit: Kubernetes manifests for GitOps"
git push origin main

# ============================================

# STEP 3: Setup GitHub Secrets

# ============================================

echo "
🔐 GitHub Secrets Setup:

1. Go to: https://github.com/daniel-tsonkov/simple_cms/settings/secrets/actions

2. Click 'New repository secret'

3. Add secret:
   Name: GITOPS_PAT
   Value: [Generate at https://github.com/settings/tokens] - Select 'repo' scope - Click 'Generate token' - Copy the token

4. Click 'Add secret'
   "

# ============================================

# STEP 4: Make Images Public (after first build)

# ============================================

echo "
📦 After first pipeline run, make images public:

1. Go to: https://github.com/daniel-tsonkov?tab=packages

2. Click on 'simple_cms-backend' package

3. Click 'Package settings'

4. Scroll to 'Danger Zone'

5. Click 'Change visibility' → 'Public'

6. Repeat for 'simple_cms-frontend' package
   "

# ============================================

# STEP 5: Setup Local Environment

# ============================================

cd ../simple_cms

# Make scripts executable

chmod +x scripts/\*.sh

# Run setup

./scripts/setup-env.sh

echo "
✅ Setup will create:

- Kind cluster
- ArgoCD
- Prometheus & Grafana
- Port forwards
  "

# ============================================

# STEP 6: Apply ArgoCD Application

# ============================================

echo "
After setup completes, run:

kubectl apply -f argocd/application.yaml

Then check status:

kubectl get application simple_cms -n argocd
"

# ============================================

# STEP 7: Trigger First Build

# ============================================

echo "
To trigger first pipeline:

# Make a small change

echo '// CI/CD test' >> backend/server.js

# Commit and push

git add .
git commit -m 'test: trigger CI/CD pipeline'
git push origin main

# Watch pipeline at:

https://github.com/daniel-tsonkov/simple_cms/actions
"

# ============================================

# STEP 8: Access Services

# ============================================

echo "
🌐 Access URLs:

ArgoCD: https://localhost:8080
Grafana: http://localhost:3001
Prometheus: http://localhost:9090

Get ArgoCD password:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

Grafana credentials:
Username: admin
Password: admin123
"

# ============================================

# STEP 9: Verify Everything Works

# ============================================

echo "
✅ Verification Checklist:

1. Cluster running:
   kubectl get nodes

2. ArgoCD ready:
   kubectl get pods -n argocd

3. Prometheus ready:
   kubectl get pods -n monitoring

4. Application deployed:
   kubectl get pods -n simple_cms

5. Pipeline passed:
   Check: https://github.com/daniel-tsonkov/simple_cms/actions

6. ArgoCD synced:
   Check: https://localhost:8080

7. Metrics visible:
   Check: http://localhost:3001
   "

# ============================================

# CLEANUP (when needed)

# ============================================

echo "
🧹 To cleanup everything:

./scripts/cleanup-env.sh
"


# small change
Lorem ipsum dolor sit amet.