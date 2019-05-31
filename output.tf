/*
 * Kubernetes
 */
output "K8S_INGRESS_FQDN" {
  value = "${azurerm_public_ip.ingress_ip.fqdn}"
  description = "Kubernetes Ingress FQDN"
}

output "AKS_RESOURCE_GROUP" {
  value = "${azurerm_resource_group.main.name}"
  description = "The main resource group of the AKS Resource"
}

output "KUBE_CONFIG_PATH" {
  value = "${local_file.kube_config.filename}"
}

