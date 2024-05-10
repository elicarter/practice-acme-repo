variable "aws_instance_type" {
  description = "Instance type for AWS EC2 instance"
  default     = "t2.micro"
}

variable "gcp_instance_type" {
  description = "Instance type for GCP VM instance"
  default     = "e2-medium"
}