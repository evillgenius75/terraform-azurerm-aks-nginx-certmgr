/*
 * Common
 */
variable "PROJECT" {
  description = "DNS-compatible Project Prefix"
}

variable "INSTANCE" {
  description = "DNS-compatible Instance Name"
}

variable "ENVIRONMENT" {
  description = "DNS-compatible Environment Name (dev, stag, prod)"
}

variable "REGION" {
  description = "Azure Region"
}
/*
 * VNET
 */
variable "VNET_NAME" {
  type = "string"
}
variable "VNET_ADDR_SPACE" {
  description = "The address space that is used by the virtual network."
  default     = "10.10.0.0/16"
}

variable "DNS_SERVERS" {
  description = "The DNS servers to be used with vNet."
  default     = []
}
variable "SUBNET_NAMES" {
  description = "A list of public subnets inside the vNet."
  default     = ["aks-subnet"]
}
variable "SUBNET_PREFIXES" {
  description = "The address prefix to use for the subnet."
  default     = ["10.10.1.0/24"]
}

/*
 * AKS
 */

variable "AKS_SSH_ADMIN_KEY" {
  description = "Admin SSH Public Key for AKS Agent VMs"
}
variable "K8S_VER" {
  type = "string"
}

variable "ADMIN_USER" {
  type = "string"
}
variable "NODE_COUNT" {
  type = "string"
}
variable "NODE_SIZE" {
  type = "string"
}
variable "SERVICE_CIDR" {
  default = "10.0.0.0/16"
  description ="Used to assign internal services in the AKS cluster an IP address. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections."
  type = "string"
}
variable "DNS_IP" {
  default = "10.0.0.10"
  description = "should be the .10 address of your service IP address range"
  type = "string"
}
variable "DOCKER_CIDR" {
  default = "172.17.0.1/16"
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Default of 172.17.0.1/16."
}

/*
 * K8S
 */

variable "K8S_KUBE_CONFIG" {
  description = "Path to Kube Config File"
}

variable "K8S_HELM_HOME" {
  description = "Path to Helm Home Directory"
}

variable "tiller_version" {
  default = "2.14.0"
  description = "Tiller Version (without prefix v)."
}

/*
 * MYSQL
 */

 variable "mysql_sku_name" {
  type   = "string"
}

variable "mysql_sku_capacity" {
  type   = "string"
}

variable "mysql_sku_tier" {
  type   = "string"
}

variable "mysql_sku_gen" {
  type   = "string"
}

variable "mysql_stor_size" {
  type = "string"
}

variable "mysql_stor_retention" {
  type = "string"
}

variable "mysql_stor_geobackup" {
  type = "string"
}

variable "mysql_adminuser" {
  type = "string"
}

variable "mysql_adminpass" {
  type = "string"
}

variable "mysql_version" {
  type = "string"
}

variable "mysql_sslenforce" {
  type = "string"
}

variable "mysql_chartset" {
  type = "string"
}

variable "mysql_collation" {
  type = "string"
}

# variable "mysql_fw_startip" {
#   type = "string"
# }

# variable "mysql_fw_endip" {
#   type = "string"
# }