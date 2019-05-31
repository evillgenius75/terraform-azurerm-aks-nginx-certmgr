/*
 * Kubernetes
 */
output "K8S_INGRESS_FQDN" {
  value = "${azurerm_public_ip.ingress_ip.fqdn}"
  description = "Kubernetes Ingress FQDN"
}
