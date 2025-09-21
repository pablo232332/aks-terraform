data "azurerm_client_config" "current" {}


resource "azurerm_kubernetes_cluster" "cluster" {

  name                = var.cluster_name
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.clusteer_dns_prefix
  kubernetes_version = var.kubernetes_version
  sku_tier = var.aks_sku_tier      #default or Standard, & Premium
  automatic_upgrade_channel = "node-image"    # patch, rapid, node-image and stable
  cost_analysis_enabled = false     # default or true with standard and premium sku_tier
  
  tags = var.tags
  
  identity {
    type = "SystemAssigned" #AKS creates system managed identity to manage lifecycle of other resources
  }


  node_os_upgrade_channel = "NodeImage" # default
  node_resource_group = "aks-managed-rg"
  
  default_node_pool {
    name       = var.sys_node_pool_name
    vm_size    = var.vm_size
    kubelet_disk_type = "OS" 
    os_disk_type = "Managed" # default
    max_pods = var.node_pool_max_pods
    auto_scaling_enabled = var.node_pool_scaling 
    type = "VirtualMachineScaleSets"
    max_count = 4
    min_count = 2
    node_count = 2
    node_public_ip_enabled = false 
    scale_down_mode = "Delete"
    only_critical_addons_enabled = var.default_node_pool_only_critical_addons 
    os_disk_size_gb = var.node_pool_os_disk_size_gb
    os_sku = "Ubuntu"
    vnet_subnet_id = azurerm_subnet.aks_sys_subnet.id
    upgrade_settings {
      drain_timeout_in_minutes = 0
      node_soak_duration_in_minutes = 0
      max_surge = "10%"

    }

  }

  run_command_enabled = true 
  storage_profile {
    blob_driver_enabled = true 
    disk_driver_enabled = true  
    file_driver_enabled = false 
    snapshot_controller_enabled = true #default
  }
  support_plan = "KubernetesOfficial" 
  
  
  auto_scaler_profile {
    max_graceful_termination_sec = var.autoscaler_max_graceful_termination_sec 
    max_node_provisioning_time = var.autoscaler_max_node_provisioning_time 
    max_unready_nodes = var.autoscaler_max_unready_nodes 
    scale_down_delay_after_add = "5m"
    skip_nodes_with_local_storage = true
    skip_nodes_with_system_pods = true  
  }

  workload_autoscaler_profile {
    vertical_pod_autoscaler_enabled = true
  }


  network_profile {
    network_plugin = "azure" 
    # network_mode = "bridge"  
    network_policy = "azure" 
    network_plugin_mode = "overlay"
    outbound_type = "loadBalancer" 
    pod_cidr = var.pod_cidr
    service_cidr = var.service_cidr
    dns_service_ip = var.dns_service_ip
    ip_versions = ["IPv4"]
    load_balancer_sku = "standard"
  }
  private_cluster_enabled = var.private_cluster_enabled
  role_based_access_control_enabled = true

  #security related - Azure RBAC is disabled by default
  azure_policy_enabled = var.azure_policy_enabled
  local_account_disabled = var.local_account_disabled # default value

  
  maintenance_window {
    allowed {
      day = "Thursday"
      hours = [1] 
    }
  }
  
  
  maintenance_window_auto_upgrade {
    frequency = "RelativeMonthly"
    interval = 1
    duration = 4
    day_of_week = "Sunday"
    week_index = "Second"
    start_time = "2:00"
    utc_offset = "-07:00"
    not_allowed {
      start = "2025-12-24T00:00:00Z"
      end =  "2025-12-26T00:00:00Z"
    }
  }
  maintenance_window_node_os {
    frequency = "Weekly"
    interval = 1
    duration = 4
    day_of_week = "Tuesday"
    start_time = "2:00"
    utc_offset = "-07:00"
    not_allowed {
      start = "2025-12-24T00:00:00Z"
      end =  "2025-12-26T00:00:00Z"
    }
  }

  image_cleaner_enabled = true
  image_cleaner_interval_hours = 168 # 7 days in hours

}
