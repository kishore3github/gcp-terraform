# provider "google" {
#   project     = "sodium-inkwell-441501-j1"
#   region      = "asia-south1"
#   credentials = file("C:/Users/kchellab/AppData/Roaming/gcloud/application_default_credentials.json")
# }

provider "google" {
  # project = data.google_client_config.current.project
  region  = "asia-south1"
  zone    = "asia-south1-a"
  credentials = file("C:/Users/kchellab/AppData/Roaming/gcloud/application_default_credentials.json")
}

data "google_client_config" "current" {
  
}

locals {
  project_id = data.google_client_config.current.id
}

