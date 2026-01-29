terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

# Namespace
resource "kubernetes_namespace" "simple_cms" {
  metadata {
    name = "simple_cms"
    
    labels = {
      name        = "simple_cms"
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

# ArgoCD Namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    
    labels = {
      name       = "argocd"
      managed-by = "terraform"
    }
  }
}

# Install ArgoCD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.51.6"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }
}

# Monitoring Namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    
    labels = {
      name       = "monitoring"
      managed-by = "terraform"
    }
  }
}

# Install Prometheus Stack via Helm
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "55.0.0"

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }
}

# ConfigMap for Grafana Dashboard
resource "kubernetes_config_map" "grafana_dashboard" {
  metadata {
    name      = "simple_cms-dashboard"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "simple_cms-dashboard.json" = file("${path.module}/../../observability/grafana-dashboard.json")
  }
}