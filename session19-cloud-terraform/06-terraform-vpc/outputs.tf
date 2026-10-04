output "vpc_id" {
  description = "ID of the DoomLord VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the DoomLord VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the DoomLord public subnet."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the DoomLord private subnet."
  value       = aws_subnet.private.id
}

output "web_security_group_id" {
  description = "ID of the DoomLord web security group."
  value       = aws_security_group.web.id
}

output "internal_security_group_id" {
  description = "ID of the DoomLord internal security group."
  value       = aws_security_group.internal.id
}