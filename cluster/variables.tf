variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "Berlin-eks-cluster"
}

# variable "vpc_cidr" {
#   type        = string
#   description = "CIDR block for VPC"
#   default     = "10.0.0.0/24"
# }

# variable "vpc_name" {
#   type        = string
#   description = "vpc name"
#   default     = "my-eks-vpc-01"
# }

variable "region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "cluster_version" {
  type        = string
  description = "Kubernet required version"
  default     = "1.23"
  # default = "1.22"
}
