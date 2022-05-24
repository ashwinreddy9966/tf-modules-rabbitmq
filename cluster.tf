resource "aws_mq_broker" "rabbitmq" {
  broker_name = "roboshop1-${var.ENV}"

  engine_type        = "RabbitMQ"
  engine_version     = var.RABBITMQ_ENGINE_VERSION
  host_instance_type = var.RABBITMQ_INSTANCE_TYPE
  security_groups    = [aws_security_group.rabbitmq.id]
  subnet_ids         = [data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0]]

  user {
    username = "roboshop"
    password = "RoboShop1234"
  }
}

resource "aws_security_group" "rabbitmq" {
  name        = "roboshop-rabbitmq-${var.ENV}"
  description = "roboshop-rabbitmq-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "Allows rabbitmq Port"
    from_port   = var.RABBITMQ_PORT
    to_port     = var.RABBITMQ_PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSTATION_IP]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSTATION_IP]
  }

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








