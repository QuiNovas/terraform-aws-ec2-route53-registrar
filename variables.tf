variable "dead_letter_arn" {
  description = "The arn for the SNS topic that handles dead letters"
  type        = "string"
}

variable "dns_name_prefix" {
  default `   = ""
  description = "The prefix to put before the record name."
  type        = "string"
}

variable "dns_name_suffix" {
  default `   = ""
  description = "The suffix to put after the record name."
  type        = "string"
}

variable "dns_ttl" {
  default     = 300
  description = "The TTL on the created DNS records."
  type        = "string"
}

variable "ec2_instance_tags" {
  default     = {}
  description = "A map of key/value pairs for tags to match. The value is treated as a regular expression for matching purposes."
  type        = "map"
}

variable "hosted_zone_id" {
  description = "The ID that Amazon Route 53 assigned to the hosted zone when you created it. This is the zone that all record sets will be created in."
  type        = "string"
}

variable "kms_key_arn" {
  description = "The arn of the KMS key used to encrypt the environment variables"
  type        = "string"
}

variable "multi_value_answer" {
  default     = false
  description = "f false, the new label will be dns_name_prefix + ec2-dns-label + dns_name_prefix. If true, the new label will be dns_name_prefix + dns_name_prefix. Defaults to false"
  type        = "string"
}

variable "name_prefix" {
  default     = ""
  description = "The prefix to place on all created resources"
  type        = "string"
}
