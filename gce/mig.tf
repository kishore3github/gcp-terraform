# Health Check Resource
resource "google_compute_health_check" "tcp_healthcheck" {
  name               = "healthcheck-2"
  check_interval_sec = 20
  timeout_sec        = 5

  tcp_health_check {
    port          = 80
    proxy_header  = "NONE"
  }

  healthy_threshold   = 2
  unhealthy_threshold = 2
}

# Instance Group Manager Resource
resource "google_compute_region_instance_group_manager" "instance_group" {
  name               = "instance-group-1"
  base_instance_name = "instance-group-1"
  description        = "Instance group created via Terraform"
  target_size        = 1
  region = var.region_1

  version {
    instance_template = google_compute_instance_template.template-2.self_link
  }

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 443
  }

  # Zones are handled directly by the instance group manager
#   zones = [
#     "asia-south1-c",
#     "asia-south1-b",
#     "asia-south1-a"
#   ]

  auto_healing_policies {
    health_check      = google_compute_health_check.tcp_healthcheck.self_link
    initial_delay_sec = 300
  }

  update_policy {
    type                = "PROACTIVE"
    minimal_action      = "RESTART"
    max_surge_fixed     = 0
    max_unavailable_fixed = 3
    replacement_method  = "RECREATE"
  }
}

# Autoscaler Resource
resource "google_compute_region_autoscaler" "instance_group_autoscaler" {
  depends_on = [ google_compute_instance_template.template ]
  name   = "instance-group-1-autoscaler"
  region = var.region_1

  target = google_compute_region_instance_group_manager.instance_group.self_link

  autoscaling_policy {
    min_replicas = 1
    max_replicas = 5

    cpu_utilization {
      target = 0.6
    }

    load_balancing_utilization {
      target = 0.3
    }

    cooldown_period = 60
  }
}


output "instance_group_self_link" {
  value = google_compute_region_instance_group_manager.instance_group.self_link
}

output "autoscaler_self_link" {
  value = google_compute_region_autoscaler.instance_group_autoscaler.self_link
}

output "health_check_self_link" {
  value = google_compute_health_check.tcp_healthcheck.self_link
}


# 4. Load Balancer Backend Service
resource "google_compute_backend_service" "backend_service" {
  depends_on = [ google_compute_region_instance_group_manager.instance_group ]
  name                = "backend-service"
  protocol            = "HTTP"
  health_checks       = [google_compute_health_check.tcp_healthcheck.self_link]
  backend {
    group = google_compute_region_instance_group_manager.instance_group.instance_group
  }

  timeout_sec = 300
}

# 5. URL Map for Routing (Assuming HTTP load balancer)
resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

# 6. HTTP Proxy (Frontend configuration)
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

# 7. Global Forwarding Rule to expose the load balancer
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.global_ip.address
}

# 8. Global IP Address (Frontend IP)
resource "google_compute_global_address" "global_ip" {
  name = "global-ip"
}

output "load_balancer_ip" {
  value = google_compute_global_address.global_ip.address
}
