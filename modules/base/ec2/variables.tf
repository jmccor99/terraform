variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_security_group_id" {
  description = ""
  type        = string
  default     = ""
}

variable "private_security_group_id" {
  description = ""
  type        = string
  default     = ""
}