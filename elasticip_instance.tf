resource "aws_eip" "jobnav2022_eip" { 
    count = var.number_of_instances
    vpc = true    
    tags = {
        Name = "eip-${aws_instance.jobnav2022_ec2[count.index].tags.Name}"
    }
    lifecycle {
        prevent_destroy = false
    }
}
resource "aws_eip_association" "eip_assoc" {
    count = var.number_of_instances
    instance_id   = aws_instance.jobnav2022_ec2[count.index].id
    allocation_id = aws_eip.jobnav2022_eip[count.index].id
    depends_on = [
      aws_instance.jobnav2022_ec2
    ]
}