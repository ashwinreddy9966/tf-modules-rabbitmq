resource "aws_mq_broker" "rabbitmq" {
  broker_name = "example"

  engine_type        = "RabbitMQ"
  engine_version     = "3.9.16"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.rabbitmq.id]

  user {
    username = "roboshop"
    password = "RoboShop1234"
  }
}

#resource "aws_db_subnet_group" "mysql" {
#    name       = "roboshop-mysql-${var.ENV}"
#    subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
#
#  tags = {
#    Name = "My DB subnet group"
#  }
#}
#
#resource "aws_db_parameter_group" "mysql" {
#  name   = "roboshop-mysql-${var.ENV}"
#  family = "mysql5.7"
#}

resource "aws_security_group" "rabbitmq" {
  name        = "roboshop-rabbitmq-${var.ENV}"
  description = "roboshop-rabbitmq-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "Allows rabbitmq Port"
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, "172.31.94.85/32"]
  }
#  ingress {
#    description = "Allows Def Subnet CIDR"
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
#  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name =  "roboshop-redis-sg-${var.ENV}"
  }
}








