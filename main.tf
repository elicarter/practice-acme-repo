terraform {
      cloud {
    organization = "ACME-TFC-DEMO"
      workspaces {
    name = "practice-acme-repo"
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
  count         = var.instance_count
  ami           = "ami-830c94e3"
  instance_type = var.aws_instance_type

  tags = {
    Name = "AcmeWebServer-${count.index + 1}"

    }
}

resource "google_compute_instance" "vm_instance" {
  count         = var.instance_count
  name          = "acmewebserver-${count.index + 1}"
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

resource "aws_subnet" "my_subnet" {
  vpc_id     = var.existing_vpc_id
  cidr_block = cidrsubnet(var.subnet_cidr, 4, count.index)
  count = length(var.availability_zones)

  availability_zone = var.availability_zones[count.index]
}

resource "aws_security_group" "elb_sg" {
  vpc_id = var.existing_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.existing_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.my_subnet.id]

  tags = {
    Name = "my-load-balancer"
  }
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.existing_vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
