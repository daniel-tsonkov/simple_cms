# Simple CMS - Architecture Documentation

## 📐 High-Level Architecture

```
┌─────────────┐
│  Developer  │
└──────┬──────┘
       │ git push
       ▼
┌─────────────────────────────────────────┐
│           GitHub Repository              │
└──────────────┬──────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────────────────┐
│               GitHub Actions CI/CD                    │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  │
│  │ Lint │→ │ Test │→ │ SAST │→ │Build │→ │ Scan │  │
│  └──────┘  └──────┘  └──────┘  └──────┘  └──────┘  │
└──────────────────────┬───────────────────────────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │  Container Registry  │
            │  (GitHub Packages)   │
            └──────────┬───────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │   GitOps Repository  │
            │  (image tag update)  │
            └──────────┬───────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │      ArgoCD          │
            │  (watches GitOps)    │
            └──────────┬───────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │  Kubernetes Cluster  │
            │  ┌────────────────┐  │
            │  │  simple_cms    │  │
            │  │   namespace    │  │
            │  └────────────────┘  │
            └──────────┬───────────┘
                       │
                       ▼
            ┌─────────────────────┐
            │   Observability      │
            │  ┌──────────────┐   │
            │  │  Prometheus  │   │
            │  │   Grafana    │   │
            │  └──────────────┘   │
            └─────────────────────┘
```

## 🏗️ Components

### 1. Application Layer

#### Backend

- **Technology**: Node.js + Express
- **Database**: SQLite (containerized)
- **Metrics**: Prometheus client
- **Health Checks**: `/health`, `/ready`
- **Metrics Endpoint**: `/metrics`

#### Frontend

- **Technology**: Vanilla JavaScript SPA
- **Web Server**: Nginx
- **Static Assets**: HTML, CSS, JS

### 2. CI/CD Pipeline

#### GitHub Actions Workflow

1. **Lint & Test** - Code quality checks
2. **Secret Scan** - TruffleHog for credential detection
3. **SAST** - Semgrep security analysis
4. **Build** - Docker image creation (Backend + Frontend)
5. **Push** - Upload to GitHub Container Registry
6. **Vulnerability Scan** - Trivy image scanning
7. **GitOps Update** - Update image tags in GitOps repo

### 3. GitOps with ArgoCD

- **Repository**: `simple_cms-gitops`
- **Sync Policy**: Automated (self-heal, prune)
- **Target**: Kubernetes `simple_cms` namespace
- **Deployment Strategy**: Rolling update

### 4. Infrastructure

#### Kubernetes Resources

- **Namespaces**: `simple_cms`, `argocd`, `monitoring`
- **Deployments**: Backend (3 replicas), Frontend (2 replicas)
- **Services**: ClusterIP (backend), LoadBalancer (frontend)
- **ServiceMonitor**: Prometheus scraping configuration

#### Terraform Infrastructure as Code

- Kubernetes provider
- Helm releases (ArgoCD, Prometheus)
- Namespace creation
- ConfigMap for Grafana dashboards

### 5. Observability

#### Prometheus Metrics

- HTTP request rate
- Request duration (p50, p95, p99)
- Error rate
- Active connections
- CPU/Memory usage
- Pod restarts

#### Grafana Dashboards

- Request Rate
- Response Time percentiles
- Error Rate percentage
- Active Connections
- Resource utilization
- Pod health

#### Alerting Rules

- High error rate (>5%)
- High response time (>2s)
- Pod down
- High CPU usage (>80%)
- High memory usage (>90%)
- Container restarts

## 🔒 Security

### Security Measures

1. **Secret Scanning** - TruffleHog in CI
2. **SAST** - Semgrep static analysis
3. **Container Scanning** - Trivy vulnerability detection
4. **Non-root Containers** - Security contexts
5. **Read-only Root Filesystem** - Where applicable
6. **Resource Limits** - CPU/Memory constraints
7. **Network Policies** - (Can be added)

## 📊 Metrics & KPIs

### DevOps Metrics

- **Deployment Frequency**: Tracked by CI/CD runs
- **Lead Time**: Commit to production time
- **MTTR**: Mean time to recovery (via alerts)
- **Change Failure Rate**: Via error rate metrics

### Application Metrics

- **Availability**: Uptime percentage
- **Latency**: p95 response time < 500ms
- **Throughput**: Requests per second
- **Error Rate**: < 1% target

## 🔄 Deployment Flow

```
1. Developer commits code
   ↓
2. GitHub Actions triggers
   ↓
3. Tests run & pass
   ↓
4. Docker images built
   ↓
5. Images pushed to registry
   ↓
6. Vulnerability scan passes
   ↓
7. GitOps repo updated with new tag
   ↓
8. ArgoCD detects change
   ↓
9. ArgoCD syncs to Kubernetes
   ↓
10. Rolling update performed
   ↓
11. Health checks pass
   ↓
12. Traffic routed to new pods
   ↓
13. Metrics visible in Grafana
```

## 🎯 Design Principles

1. **GitOps**: Single source of truth in Git
2. **Immutable Infrastructure**: Container images never modified
3. **Infrastructure as Code**: All resources defined in code
4. **Observability First**: Metrics, logs, and traces
5. **Security by Default**: Multiple security layers
6. **Automated Everything**: Minimal manual intervention
7. **Self-Healing**: Automatic recovery from failures

## 🚀 Future Improvements

- **Canary Deployments**: Progressive rollouts
- **Blue-Green Deployments**: Zero-downtime updates
- **Service Mesh**: Istio for advanced traffic management
- **Policy as Code**: OPA Gatekeeper
- **Chaos Engineering**: Litmus Chaos
- **DAST**: Dynamic application security testing
- **Multi-cluster**: Geographic distribution
- **Backup & DR**: Velero for cluster backups
