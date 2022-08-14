locals {
	ingress_rules = [{
		port        = 443
		description = "Port 443 for external ssl access"
	},
	{
		port        = 80
		description = "Port 80 for external access"
	},
    {
        port        = 22
        description = "Port 22 for SSH access"
    }]
}

resource "aws_security_group" "jobnav2022_security_group" {
	name   = "instance_sg"
	vpc_id = aws_vpc.jobnav2022_vpc.id

	dynamic "ingress" {
		for_each = local.ingress_rules

		content {
			description = ingress.value.description
			from_port   = ingress.value.port
			to_port     = ingress.value.port
			protocol    = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
		}
	}
	
	egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }
	tags = {
		Name = "Jobnav Instance security group"
	}
}
