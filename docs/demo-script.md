# Simple CMS - Demo Script (12-15 minutes)

## 🎯 Demo Objectives

- Show complete DevOps pipeline
- Demonstrate GitOps workflow
- Present observability capabilities
- Deep dive into GitOps (ArgoCD)

---

## ⏱️ Timeline

| Time      | Section                   | Duration |
| --------- | ------------------------- | -------- |
| 0-2 min   | High-Level Design         | 2 min    |
| 2-5 min   | CI/CD Pipeline            | 3 min    |
| 5-7 min   | GitOps Update             | 2 min    |
| 7-9 min   | ArgoCD Deployment         | 2 min    |
| 9-11 min  | Observability             | 2 min    |
| 11-13 min | Deep Dive: GitOps         | 2 min    |
| 13-15 min | Future Improvements + Q&A | 2 min    |

---

## 📝 Detailed Script

### **[0:00 - 2:00] 1. High-Level Solution Design**

**Opening Statement:**

> "Здравейте! Днес ще представя пълно DevOps решение за Simple CMS - уеб приложение с автоматизирана софтуерна доставка. Решението покрива над 15 теми от курса и включва deep dive в GitOps."

**Show Architecture Diagram** (`docs/architecture.md`)

**Key Points:**

- ✅ "Започваме с Git repository като source of truth"
- ✅ "Имаме GitHub Actions CI/CD pipeline"
- ✅ "Използваме GitOps pattern с ArgoCD"
- ✅ "Deploy в Kubernetes cluster"
- ✅ "Observability с Prometheus и Grafana"
- ✅ "Infrastructure as Code с Terraform"

**Topics Covered (quick mention):**

> "Решението покрива: CI/CD, GitOps, containerization, orchestration, IaC, security scanning, observability, и automation."

---

### **[2:00 - 5:00] 2. CI/CD Pipeline Demo**

**Navigate to GitHub Actions:**

```
https://github.com/daniel-tsonkov/simple-cms/actions
```

**Show Workflow File:**

```bash
cat .github/workflows/ci-cd.yml
```

**Explain Pipeline Stages:**

1. **Lint & Test**

   > "Първо правим code quality checks с ESLint и unit тестове с Jest"

   ```bash
   # Show test results
   npm run lint
   npm test
   ```

2. **Secret Scanning**

   > "TruffleHog сканира за hardcoded credentials"

   ```yaml
   - name: TruffleHog Secret Scan
     uses: trufflesecurity/trufflehog@main
   ```

3. **SAST (Static Analysis)**

   > "Semgrep прави security анализ на кода"

4. **Build & Push**

   > "Билдваме Docker images и ги качваме в GitHub Container Registry"

   ```bash
   # Show images
   docker images | grep simple-cms
   ```

5. **Vulnerability Scan**

   > "Trivy сканира образите за уязвимости"

6. **GitOps Update**
   > "След успешен scan, автоматично обновяваме GitOps репото с новия image tag"

**Trigger Pipeline:**

```bash
# Make small change
echo "// Demo change" >> backend/server.js
git add .
git commit -m "demo: trigger pipeline"
git push origin main
```

> "Сега pipeline-ът ще се стартира автоматично. Нека видим резултатите..."

**Show Pipeline Running** (while it runs, move to next section)

---

### **[5:00 - 7:00] 3. GitOps Repository Update**

**Navigate to GitOps Repo:**

```
https://github.com/daniel-tsonkov/simple-cms-gitops
```

**Show Structure:**

```bash
tree k8s/
# k8s/
# ├── namespace.yaml
# ├── deployment.yaml
# ├── service.yaml
# └── servicemonitor.yaml
```

**Show Deployment YAML:**

```yaml
# Point to image tag
image: ghcr.io/daniel-tsonkov/simple-cms-backend:abc1234
```

**Explain:**

> "CI pipeline автоматично обновява този image tag. Това е single source of truth за нашия deployment."

**Show Recent Commit:**

```bash
git log --oneline -5
# ci: update image to abc1234
```

---

### **[7:00 - 9:00] 4. ArgoCD Deployment**

**Open ArgoCD UI:**

```
https://localhost:8080
```

**Login:**

- Username: `admin`
- Password: (from setup)

**Show Application:**

1. Click on `simple-cms` application
2. Show Application Tree
   - Namespace
   - Deployment (backend, frontend)
   - Service
   - Pods

**Explain Sync Status:**

> "ArgoCD автоматично следи GitOps репото. Когато се промени image tag, ArgoCD syncing започва автоматично."

**Show Sync Details:**

- Sync Status: `Synced`
- Health: `Healthy`
- Last Sync: (timestamp)

**Show Pods:**

```bash
kubectl get pods -n simple-cms -w
```

**Explain Rolling Update:**

> "Виждаме rolling update - старите pod-ове се терминират, новите стартират с health checks."

**Verify Deployment:**

```bash
kubectl get deployment -n simple-cms
# NAME                    READY   UP-TO-DATE   AVAILABLE
# simple-cms-backend      3/3     3            3
# simple-cms-frontend     2/2     2            2
```

---

### **[9:00 - 11:00] 5. Observability**

**Open Grafana:**

```
http://localhost:3001
```

**Login:**

- Username: `admin`
- Password: `admin123`

**Navigate to Dashboard:**

> "Имаме custom Grafana dashboard с real-time метрики"

**Show Panels:**

1. **Request Rate**

   > "Виждаме колко requests per second обработва приложението"

2. **Request Duration (p95)**

   > "95th percentile response time - важна метрика за user experience"

3. **Error Rate**

   > "Процент на грешки - в момента е под 1%"

4. **Active Connections**

   > "Брой активни connections към backend"

5. **Pod Restarts**
   > "Следим за неочаквани рестартове"

**Open Prometheus:**

```
http://localhost:9090
```

**Run Sample Queries:**

```promql
# Request rate
rate(http_requests_total{namespace="simple-cms"}[5m])

# p95 latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Pod status
up{namespace="simple-cms"}
```

**Show Alerts:**

```bash
kubectl get prometheusrule -n monitoring simple-cms-alerts -o yaml
```

> "Имаме alerts за high error rate, high latency, pod down, и др."

---

### **[11:00 - 13:00] 6. Deep Dive: GitOps**

**Explain GitOps Principles:**

1. **Declarative**

   > "Всичко е описано декларативно в YAML"

   ```bash
   cat k8s/deployment.yaml
   ```

2. **Versioned & Immutable**

   > "Всяка промяна е commit в Git - пълна история и audit trail"

   ```bash
   git log --graph --oneline
   ```

3. **Pulled Automatically**

   > "ArgoCD pull-ва промени автоматично, не push-ваме директно в cluster"

4. **Continuously Reconciled**
   > "ArgoCD постоянно сравнява desired state (Git) с actual state (cluster)"

**Show ArgoCD Features:**

**A) Auto-Sync**

```yaml
syncPolicy:
  automated:
    prune: true # Delete resources not in Git
    selfHeal: true # Revert manual changes
```

**B) Drift Detection**

> "Ако някой ръчно промени нещо в cluster, ArgoCD го detectva и revert-ва"

**Demo Drift:**

```bash
# Manually scale deployment
kubectl scale deployment simple-cms-backend -n simple-cms --replicas=5

# Watch ArgoCD revert it back to 3
# ArgoCD will detect drift and self-heal
```

**C) Rollback**

```bash
# Show history in ArgoCD UI
# Click "History and Rollback"
# Can rollback to any previous version
```

**D) Multi-Environment**

> "С GitOps можем лесно да управляваме dev, staging, production environments"

```
simple-cms-gitops/
├── dev/
├── staging/
└── production/
```

**Benefits:**

- ✅ Single source of truth
- ✅ Full audit trail
- ✅ Easy rollbacks
- ✅ Disaster recovery
- ✅ Multi-cluster support

---

### **[13:00 - 15:00] 7. Future Improvements + Q&A**

**Quick Mention of Improvements:**

1. **Canary Deployments**

   > "Постепенно rollout - 10% → 50% → 100%"

2. **Blue-Green Deployments**

   > "Zero-downtime deployments с две паралелни среди"

3. **Service Mesh (Istio)**

   > "Advanced traffic management, security, observability"

4. **Policy as Code (OPA Gatekeeper)**

   > "Автоматично enforcement на policies"

5. **Chaos Engineering (Litmus)**

   > "Тестване на resilience"

6. **DAST (Dynamic Application Security Testing)**

   > "Runtime security scanning"

7. **Multi-Region/Multi-Cluster**
   > "Geographic distribution за high availability"

**Closing Statement:**

> "Това е пълно DevOps решение с автоматизация от код до production. Покрива CI/CD, security, GitOps, observability, и IaC. Имаме ли въпроси?"

**Be Ready for Questions:**

- Why GitOps vs traditional CD?
- How do you handle secrets?
- What about database migrations?
- How do you test the infrastructure?
- What's the rollback procedure?

---

## 🎬 Pre-Demo Checklist

**1 Day Before:**

- [ ] Run full setup: `./scripts/setup-env.sh`
- [ ] Test pipeline end-to-end
- [ ] Verify all services are running
- [ ] Check Grafana dashboards show data
- [ ] Prepare backup slides

**1 Hour Before:**

- [ ] Start Kind cluster
- [ ] Port forward ArgoCD, Grafana, Prometheus
- [ ] Open all browser tabs
- [ ] Test pipeline with dummy commit
- [ ] Clear terminal history

**During Demo:**

- [ ] Speak clearly and confidently
- [ ] Don't rush - you have time
- [ ] If something breaks, explain and move on
- [ ] Watch the time

---

## 💡 Tips for Success

1. **Rehearse Multiple Times**
   - Practice the flow
   - Time yourself
   - Anticipate questions

2. **Have Fallback Screenshots**
   - In case of network issues
   - For slow-loading pages

3. **Explain "Why" not just "What"**
   - Why GitOps over Jenkins?
   - Why Kubernetes?
   - Why this architecture?

4. **Be Honest About Limitations**
   - "This is a demo environment"
   - "In production, we'd also add..."

5. **Stay Calm**
   - If something fails, explain what should happen
   - Show logs and troubleshoot live

---

## 🔗 Quick Links for Demo

```bash
# ArgoCD
https://localhost:8080

# Grafana
http://localhost:3001

# Prometheus
http://localhost:9090

# GitHub Actions
https://github.com/daniel-tsonkov/simple-cms/actions

# GitOps Repo
https://github.com/daniel-tsonkov/simple-cms-gitops
```

**Good luck! 🚀**
