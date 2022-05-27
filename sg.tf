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
