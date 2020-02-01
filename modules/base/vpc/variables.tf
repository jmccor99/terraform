variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}

variable "enable_dns_support" {
  description = ""
  type        = string
}

variable "enable_dns_hostnames" {
  description = ""
  type        = string
}

variable "vpc_name" {
  description = ""
  type        = string
}