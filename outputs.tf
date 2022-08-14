output "vpc_details" {
    value = data.aws_vpc.get_vpc_details.tags
}
output "aws_ec2_id" {
    value = [for instance in aws_instance.jobnav2022_ec2 : instance.id]
}
output "aws_eip_associated_id" {
    value = [for instance in aws_eip.jobnav2022_eip : instance.allocation_id]
}
output "eip_ec2_publicIP" {
    value = [for instance in aws_eip.jobnav2022_eip : instance.public_ip]
}
output "jobnav_db_internal_url" {
  value = aws_db_instance.jobnav2022_db.endpoint
}

output "jobnav_db_internal_master_db_name" {
  value = aws_db_instance.jobnav2022_db.name
}