resource "google_compute_instance_template" "template" {
  name         = "template-1"
  machine_type = "e2-micro"
  region = var.region_1

  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
    // backup the disk every day
    # resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      # Update package list
      sudo apt-get update
      
      # Install Apache web server
      sudo apt-get install -y apache2
      
      # Start Apache web server
      sudo systemctl start apache2
      
      # Ensure Apache starts on boot
      sudo systemctl enable apache2
    EOT
  }
  network_interface {
    subnetwork = "projects/sodium-inkwell-441501-j1/regions/asia-south1/subnetworks/default"

    access_config {
      network_tier = "STANDARD"
    }
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  service_account {
    email  = "646030384441-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  tags = ["http-server", "https-server", "lb-health-check"]
}


resource "google_compute_instance_template" "template-2" {
  name         = "template-2"
  machine_type = "e2-micro"
  region       = var.region_1

  # Specify the boot disk and image
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  # Metadata for startup script
  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      # Log startup process to track the script execution
      echo "Starting Apache installation and configuration" > /var/log/startup-script.log
      
      # Update package list
      sudo apt-get update >> /var/log/startup-script.log 2>&1
      
      # Install Apache web server
      sudo apt-get install -y apache2 >> /var/log/startup-script.log 2>&1
      
      # Start Apache web server
      sudo systemctl start apache2 >> /var/log/startup-script.log 2>&1
      
      # Ensure Apache starts on boot
      sudo systemctl enable apache2 >> /var/log/startup-script.log 2>&1
      
      # Confirm success
      echo "Apache installation and configuration completed" >> /var/log/startup-script.log
    EOT
  }

  # Define network configuration (ensure access to HTTP/HTTPS)
  network_interface {
    subnetwork = "projects/sodium-inkwell-441501-j1/regions/asia-south1/subnetworks/default"

    access_config {
      network_tier = "STANDARD"
    }
  }

  # Scheduling configuration for automatic restarts and handling maintenance
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  # Define service account with necessary permissions
  service_account {
    email  = "646030384441-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  # Shielded VM configuration (for enhanced security)
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  # Assign tags to enable firewall rules for HTTP/HTTPS
  tags = ["http-server", "https-server", "lb-health-check"]
}
