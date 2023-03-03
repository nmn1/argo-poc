variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "berlin-vpc-01"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/24"
}





variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "Berlin-eks-cluster"
}

variable "region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "cluster_version" {
  type        = string
  description = "Kubernet required version"
  default     = "1.24"
  # default = "1.22"
}

variable "aws_profile" {
  type        = string
  description = "Add profile to be used to access the aws."
  default     = "nagarro_eks"
}