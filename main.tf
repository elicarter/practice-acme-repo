terraform {
      cloud {
    organization = "ACME-TFC-DEMO"
      workspaces {
    name = "Test-Acme"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
    google = {
      source = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "google" {
  project = "acme-tfc-demo" 
  region  = "us-west3"
}

resource "aws_instance" "AcmeDemoServer" {
  ami           = "ami-830c94e3"
  instance_type = var.aws_instance_type

}

resource "google_compute_instance" "vm_instance" {
  name         = "acme-vm-instance"
  machine_type = var.gcp_instance_type
  zone         = "us-west3-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}