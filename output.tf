output "infra_mind_ansible_public_ip" {
  value       = aws_eip.infra_mind_ansible_ec2_eip.public_ip
  description = "The Elastic Public IP of Ansible Server"
}

output "infra_mind_ansible_private_ip" {
  value       = aws_instance.infra_mind_ansible_ec2.private_ip
  description = "The Private IP of Ansible Server"
}


output "infra_mind_elb_dns_name" {
  value       = aws_elb.infra_mind_elb.dns_name
  description = "The DNS Name of Elastic Load balancer"
}

output "infra_mind_wordpress_private_ip" {
  value       = aws_instance.infra_mind_wordpress_ec2.private_ip
  description = "The Private IP of Wordpress Server"
}

output "infra_mind_mysql_private_ip" {
  value       = aws_instance.infra_mind_mysql_ec2.private_ip
  description = "The Private IP of MYSQL Server"
}