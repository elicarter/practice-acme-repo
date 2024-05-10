output "instance_ip" {
  value = aws_instance.AcmeDemoServer[count.index].public_ip
}

output "ip" {
  value = google_compute_instance.vm_instance[count.index].network_interface.0.network_ip
}

output "public_dns" {
  value = aws_instance.AcmeDemoServer.*.public_dns
}