resource "random_string" "name_suffix" {
  length  = 8
  special = false
}

module "ec2_route53_registrar" {
  dead_letter_arn = var.dead_letter_arn
  handler         = "function.handler"
  kms_key_arn     = var.kms_key_arn
  l3_object_key   = "quinovas/ec2-route53-registrar/ec2-route53-registrar-0.0.1.zip"

  environment_variables = {
    DNS_NAME_PREFIX    = var.dns_name_prefix
    DNS_NAME_SUFFIX    = var.dns_name_suffix
    DNS_TTL            = var.dns_ttl
    EC2_INSTANCE_TAGS  = jsonencode(var.ec2_instance_tags)
    HOSTED_ZONE_ID     = var.hosted_zone_id
    MULTI_VALUE_ANSWER = var.multi_value_answer
  }

  name = "${var.name_prefix}ec2-route53-registrar-${random_string.name_suffix.result}"

  policy_arns = [
    aws_iam_policy.ec2_route53_registrar.arn,
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  ]

  policy_arns_count = 2
  runtime           = "python3.7"
  source            = "QuiNovas/lambdalambdalambda/aws"
  timeout           = 300
  version           = "3.0.0"
}

resource "aws_iam_policy" "ec2_route53_registrar" {
  name   = "${var.name_prefix}ec2-route53-registrar--${random_string.name_suffix.result}"
  policy = data.aws_iam_policy_document.ec2_route53_registrar.json
}

resource "aws_cloudwatch_event_rule" "ec2_route53_registrar" {
  description = "Event that runs the ec2-route53-registrar lambda for running, shutting-down, stopped, stopping, or terminated ec2 states."

  event_pattern = <<PATTERN
  {
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "detail": {
    "state": [
      "running",
      "shutting-down",
      "stopped",
      "stopping",
      "terminated"
    ]
  }
}
PATTERN


  name = "${var.name_prefix}ec2-route53-registrar-${random_string.name_suffix.result}"
}

resource "aws_lambda_permission" "ec2_route53_registrar" {
  action = "lambda:InvokeFunction"
  function_name = module.ec2_route53_registrar.name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.ec2_route53_registrar.arn
  statement_id = "${module.ec2_route53_registrar.name}-execution-permission"
}

resource "aws_cloudwatch_event_target" "ec2_route53_registrar" {
  depends_on = [aws_lambda_permission.ec2_route53_registrar]
  arn = module.ec2_route53_registrar.arn
  rule = aws_cloudwatch_event_rule.ec2_route53_registrar.name
}

