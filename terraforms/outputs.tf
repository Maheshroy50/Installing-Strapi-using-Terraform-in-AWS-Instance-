output "strapi_instance_ip" {
  description = "Public IP of the Strapi Server"
  value       = module.compute.instance_public_ip
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i modules/compute/${var.key_name}.pem ubuntu@${module.compute.instance_public_ip}"
}
