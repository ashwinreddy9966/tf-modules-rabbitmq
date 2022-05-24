#resource "aws_route53_record" "record" {
#  zone_id = data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ID
#  name    = "rabbitmq-${var.ENV}.${data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ZONE}"
#  type    = "CNAME"
#  ttl     = "60"
#  records = [aws_mq_broker.aws_mq_broker.????]
#}
output "rabbitmq" {
  value = aws_mq_broker.aws_mq_broker
}