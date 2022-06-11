#resource "aws_mq_broker" "rabbitmq" {
#  broker_name = "roboshop1-${var.ENV}"
#
#  engine_type        = "RabbitMQ"
#  engine_version     = var.RABBITMQ_ENGINE_VERSION
#  host_instance_type = var.RABBITMQ_INSTANCE_TYPE
#  security_groups    = [aws_security_group.rabbitmq.id]
#  subnet_ids         = [data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0]]
#
#  user {
#    username = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RABBITMQ_USERNAME"]
#    password = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RABBITMQ_PASSWORD"]
#  }
#}

resource "aws_spot_instance_request" "rabbitmq" {
  ami                     = data.aws_ami.ami.id
  instance_type           = var.RABBITMQ_INSTANCE_TYPE
  wait_for_fulfillment    = true
  vpc_security_group_ids  = [aws_security_group.rabbitmq.id]
  subnet_id               = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0]

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}

resource "aws_ec2_tag" "tag-for-rabbitmq" {
  resource_id = aws_spot_instance_request.rabbitmq.id
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}

resource "null_resource" "app-deploy" {
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.rabbitmq.private_ip
      user     = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_USERNAME"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_PASSWORD"]
    }
    inline = [
      "sudo labauto ansible",
      "ansible-pull -U https://github.com/ashwinreddy9966/ansible roboshop-pull.yml -e ENV=${var.ENV} -e COMPONENT=rabbitmq"
    ]
  }
}








