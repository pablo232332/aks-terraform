resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
    name = var.usr_node_pool_name
    kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
    vm_size    = var.vm_size
    
    kubelet_disk_type = "OS" 
    os_disk_type = "Managed"
    max_pods = var.node_pool_max_pods
    auto_scaling_enabled = var.node_pool_scaling
    mode = "User"
    max_count = 4
    min_count = 2
    node_count = 2
    node_public_ip_enabled = true
    scale_down_mode = "Delete"
    os_disk_size_gb = var.node_pool_os_disk_size_gb
    os_sku = "Ubuntu"
    os_type = "Linux" 
    vnet_subnet_id = azurerm_subnet.aks_usr_subnet.id
    node_network_profile {
      allowed_host_ports {
        port_start = 30011
        port_end = 30011
        protocol = "TCP"
      }
      allowed_host_ports {
        port_start = 22
        port_end = 22
        protocol = "TCP"
      }
      application_security_group_ids = [azurerm_application_security_group.web_asg.id]
    }
  
}
