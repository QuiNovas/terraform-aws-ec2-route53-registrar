data "aws_route53_zone" "zone" {
  zone_id = var.hosted_zone_id
}

data "aws_iam_policy_document" "ec2_route53_registrar" {
  statement {
    actions = [
      "route53:GetHostedZone",
    ]
    resources = [
      "*",
    ]
    sid = "GetHostedZone"
  }
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.zone.zone_id}",
    ]
    sid = "ChangeResourceRecordSets"
  }
}

