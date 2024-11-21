variable "project_id" {
  type    = string
  default = "sodium-inkwell-441501-j1"
}

variable "region_1" {
  type    = string
  default = "asia-south1"
}

variable "region_2" {
  type    = string
  default = "asia-south2"
}
variable "zone" {
  type    = string
  default = "asia-south1-a"
}

variable "vpc_name" {
  type    = string
  default = "my-vpc"
}

variable "ip_cidr_range_1" {
  type    = string
  default = "10.0.1.0/24"
}

variable "ip_cidr_range_2" {
  type    = string
  default = "10.0.2.0/24"
}

variable "subnet1_name" {
    type = string
    default = "my_subnet_1"
  
}

variable "subnet2_name" {
    type = string
    default = "my_subnet_2"
  
}