variable "aws_instance_type" {
  description = "Instance type for AWS EC2 instance"
  default     = "t2.micro"
}

variable "gcp_instance_type" {
  description = "Instance type for GCP VM instance"
  default     = "e2-medium"
}

variable "existing_vpc_id" {
    description = "Existing VPC ID"
  default = "vpc-0532e092970c8807e"
}

variable "subnet_cidr" {
  default = "172.31.16.0/20"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}