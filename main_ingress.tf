# ingress ip
resource "azurerm_public_ip" "ingress_ip" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}pip"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  allocation_method = "Static"
  domain_name_label            = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}"

  tags {
    project = "${var.PROJECT}"
    instance = "${var.INSTANCE}"
    environment = "${var.ENVIRONMENT}"
  }
}

provider "kubernetes" {
  config_path            = "${local_file.kube_config.filename}"
}

resource "kubernetes_service_account" "tiller_sa" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller_sa_cluster_admin_rb" {
    metadata {
        name = "tiller-cluster-role"
    }
    role_ref {
        kind = "ClusterRole"
        name = "cluster-admin"
        api_group = "rbac.authorization.k8s.io"
    }
    subject {
        kind = "ServiceAccount"
        name = "${kubernetes_service_account.tiller_sa.metadata.0.name}"
        namespace = "kube-system"
        api_group = ""
    }
}

# helm provider
provider "helm" {
  debug = true
  home  = "${var.K8S_HELM_HOME}"
  namespace       = "kube-system"
  service_account = "tiller"
  install_tiller  = "true"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v${var.TILLER_VER}"
  kubernetes {
    config_path = "${local_file.kube_config.filename}"
  }
}

# ingress
resource "helm_release" "ingress" {
  name      = "ingress"
  chart     = "stable/nginx-ingress"
  namespace = "kube-system"
  timeout   = 1800
  depends_on = [
    "azurerm_kubernetes_cluster.main",
    "azurerm_public_ip.ingress_ip",
    "kubernetes_cluster_role_binding.tiller_sa_cluster_admin_rb"
  ]
  set {
    name  = "controller.service.loadBalancerIP"
    value = "${azurerm_public_ip.ingress_ip.ip_address}"
  }
  set {
    name = "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group\""
    value = "${azurerm_resource_group.main.name}"
  }
}

# cert-manager
resource "local_file" "crdinstall" {
  # kube config
  filename = "${var.K8S_KUBE_CONFIG}"
  content  = "${azurerm_kubernetes_cluster.main.kube_config_raw}"
  depends_on = [ "helm_release.ingress" ]
  # helm init
  provisioner "local-exec" {
    command = "./cert-crd_install.sh"
    environment {
      KUBECONFIG = "${var.K8S_KUBE_CONFIG}"
      HELM_HOME  = "${var.K8S_HELM_HOME}"
    }
  }
}

data "helm_repository" "jetstack" {
    name = "jetstack"
    url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert-manager" {
    name       = "cert-manager"
    repository = "${data.helm_repository.jetstack.metadata.0.name}"
    chart      = "cert-manager"
    namespace  = "cert-manager"
    version    = "v0.8.0"
    wait       = false

    depends_on = [ "local_file.crdinstall" ]
}

resource "local_file" "cert-manager-check" {
  # kube config
  filename = "${var.K8S_KUBE_CONFIG}"
  content  = "${azurerm_kubernetes_cluster.main.kube_config_raw}"
  depends_on = [ "helm_release.cert-manager" ]
  # helm init
  provisioner "local-exec" {
    command = "./cert-check.sh"
    environment {
      KUBECONFIG = "${var.K8S_KUBE_CONFIG}"
      HELM_HOME  = "${var.K8S_HELM_HOME}"
    }
  }
}


# # letsencrypt
# resource "helm_release" "letsencrypt" {
#   name      = "letsencrypt"
#   chart     = "${path.root}/charts/letsencrypt/"
#   namespace = "kube-system"
#   timeout   = 1800
#   depends_on = ["local_file.cert-manager-check" ]
# }
