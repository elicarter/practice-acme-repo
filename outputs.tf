output "instance_public_ips" {
  value = [for instance in aws_instance.AcmeDemoServer : instance.public_ip]
}

output "ip" {
  value = [for instance in google_compute_instance.vm_instance : instance.network_interface.0.network_ip]
}

output "public_dns" {
  value = aws_instance.AcmeDemoServer.*.public_dns
}