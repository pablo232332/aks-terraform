variable "resource_group_name" {
  type = string
  default = "da-aks-rg01"
  description = "A new resource group"
}

variable "region" {
  type = string
  default = "Canada Central"
  description = "Azure Location for your resources"
}


variable "vnet_cidr" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_sys_subnet_prefix" {
  description = "Address prefix for AKS system subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "aks_usr_subnet_prefix" {
  description = "Address prefix for AKS user subnet"
  type        = list(string)
  default     = ["10.0.10.0/24"]
}

variable "allowed_ports" {
  description = "List of allowed destination ports"
  type        = list(string)
  default     = ["22", "30011"]
}

variable "source_address_prefix" {
  description = "Source address prefix for NSG rule"
  type        = string
  default     = "Internet"
}

#aks-cluster variables

variable "cluster_name" {
  type = string
  default = "da-aks-cluster"
  description = "Cluster name"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the AKS cluster."
  type        = string
  default     = "1.30.0" # Using a more stable version, check Azure AKS documentation for latest supported
}

variable "clusteer_dns_prefix" {
  type = string
  default = "da-aks"
  description = "DNS prefix required for the cluster"
}

variable "aks_sku_tier" {
  description = "SKU tier for the AKS cluster (Free, Standard, Premium)."
  type        = string
  default     = "Free"
  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.aks_sku_tier)
    error_message = "Valid values for aks_sku_tier are Free, Standard, or Premium."
  }
}

variable "tags" {
  type = map(string)
  default = {
    "Env" = "da-demo"
  }
}

variable "sys_node_pool_name" {
  type = string
  default = "default"
  description = "VM size for cluster nodes"
}

variable "vm_size" {
  type = string
  default = "Standard_D2ps_V6"
  description = "VM size for cluster nodes"
}

variable "node_pool_max_pods" {
  description = "Maximum number of pods that can run on a node in the default node pool."
  type        = number
  default     = 100
}

variable "node_pool_scaling" {
  type = bool
  default = true
  description = "Enable AutoScaling for system node pool"
}

variable "default_node_pool_only_critical_addons" {
  description = "If true, only critical addons will be scheduled on the default node pool, preventing user workloads. Typically true for system-only node pools."
  type        = bool
  default     = true 
}

variable "node_pool_os_disk_size_gb" {
  description = "Size of the OS disk in GB for nodes in the default node pool."
  type        = number
  default     = 50
}

# --- Auto Scaler Profile Variables ---
variable "autoscaler_max_graceful_termination_sec" {
  description = "The maximum number of seconds to wait for pods to terminate gracefully during scale down."
  type        = number
  default     = 120
}

variable "autoscaler_max_node_provisioning_time" {
  description = "The maximum time (e.g., '10m', '1h') for a node to be ready."
  type        = string
  default     = "10m"
}

variable "autoscaler_max_unready_nodes" {
  description = "The maximum number of unready nodes permitted. Setting a higher value will reduce the chance of nodes popping up."
  type        = number
  default     = 3
}

# --- Network Profile Variables ---
variable "pod_cidr" {
  description = "The CIDR block for pods within the Kubernetes cluster."
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "The CIDR block for services within the Kubernetes cluster."
  type        = string
  default     = "10.245.0.0/20"
}
variable "dns_service_ip" {
  description = "The IP address for the Kubernetes DNS service."
  type        = string
  default     = "10.245.0.10"
}

variable "private_cluster_enabled" {
  description = "Whether to enable a private cluster, making the API server accessible only from within the VNet."
  type        = bool
  default     = false # Recommended to be true for production
}

variable "azure_policy_enabled" {
  description = "Whether Azure Policy is enabled for the AKS cluster."
  type        = bool
  default     = false # Consider enabling for governance
}

variable "local_account_disabled" {
  description = "Whether local accounts are disabled for the cluster. Recommended true for Azure AD integration."
  type        = bool
  default     = false # Consider enabling for enhanced security
}

variable "usr_node_pool_name" {
  type = string
  default = "userpool"
  description = "VM size for cluster nodes"
}
