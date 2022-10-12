variable "name" {
  type        = string
  default     = "bastion-host"
  description = "name"
}

variable "instances_number" {
  type        = number
  default     = 1
  description = "number of instances to launch"
}

variable "vpc_name" {
  type        = string
  description = "The VPC name where the task will be performed."
}

variable "subnet_name" {
  type        = list(any)
  description = "List of one or more subnet names where the task will be performed."
}

variable "region" {
  type        = string
  description = "The AWS Region."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "description"
}

variable "username" {
  type        = string
  default     = "bastion-user"
  description = "description"
}

variable "policies" {
  type = list(any)
  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

variable "ssm_group_name" {
  type        = string
  default     = "SSMUserGroup"
  description = "description"
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Associate public IP address"
}

variable "switch_role_arn" {
  type        = string
  description = "Costumer Switch Role ARN."
}
