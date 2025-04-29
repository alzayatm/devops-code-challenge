variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-2"
}

variable "account_id" {
  description = "Your AWS Account ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to run ECS services in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to ECS services"
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "devops-challenge-cluster"
}
