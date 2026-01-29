output "argocd_server_url" {
  description = "ArgoCD server URL"
  value       = "Access ArgoCD at: kubectl port-forward svc/argocd-server -n argocd 8080:443"
}

output "argocd_admin_password" {
  description = "Command to get ArgoCD admin password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  sensitive   = true
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "Access Grafana at: kubectl port-forward svc/prometheus-grafana -n monitoring 3001:80"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "Access Prometheus at: kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090"
}

output "simple_cms_namespace" {
  description = "Simple CMS namespace"
  value       = kubernetes_namespace.simple_cms.metadata[0].name
}