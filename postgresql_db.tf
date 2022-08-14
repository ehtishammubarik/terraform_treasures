
resource "aws_security_group" "jobnav2022_db_security_group" {
  name        = "jobnav2022_db_security_group"
  description = "JobNav Dev DB Security Group"
  vpc_id      = aws_vpc.jobnav2022_vpc.id

  tags = {
    Name = "jobnav2022_db_security_group"
  }
}

resource "aws_security_group_rule" "jobnav2022_db_security_group_rule" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jobnav2022_security_group.id
  security_group_id        = aws_security_group.jobnav2022_db_security_group.id
  description              = "access from EC instances internally"
}

resource "aws_security_group_rule" "bastian_run" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jobnav2022_db_security_group.id // Manually retrieved from AWS Console from security group created by eks
  description       = "bastion_host_jobnav2022_db_security_group_rule"
}

resource "aws_db_instance" "jobnav2022_db" {
  db_subnet_group_name    = aws_db_subnet_group.jobanv2022_subnet_region_pvt.name
  db_name                 = "user_service"
  identifier              = "jobnav2022"
  allocated_storage       = 20
  instance_class          = "db.t3.small"
  engine                  = "postgres"
  engine_version          = "14"
  username                = "jobnav"
  password                = "ZWxhcml1bQo="
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.jobnav2022_db_security_group.id]
  parameter_group_name    = "default.postgres14"
  availability_zone       = "us-east-1a"
  port                    = 5432
  skip_final_snapshot     = true
  backup_retention_period = 7
  copy_tags_to_snapshot   = true
}
# locals {
#   timestamp = "${timestamp()}"
#   timestamp_sanitized = "${replace("${local.timestamp}", "/[- TZ:]/", "")}"
