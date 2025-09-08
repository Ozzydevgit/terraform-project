variable "region" {
  type = string 
  default = "us-east-1"
}

variable "az" {
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]
    description = "availabilty zones"
}

variable "cidr_block" {
    type = list(string)
    default = ["192.168.1.0/24", "192.168.2.0/24"]
    description = "cidr blocks"
}
variable "subnet_tags" {
  description = "A map of tags to assign to the subnets"
  type        = map(string)
  default     = {
    Name        = "public-subnet"
    Environment = "development"
  }
}

variable "route_table_names" {
  type        = list(string)
  default     = ["public-route-table-0", "public-route-table-1"]
  description = "Route table names"
}

variable "ami_id" {
  type        = string
  default     = "ami-04b70fa74e45c3917"  # Replace with a valid AMI ID
  description = "The AMI ID to use for the instances"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The instance type to use for the instances"
}

variable "name" {
  type        = string
  default     = "ozzy"
  description = "The name of my infra"
}
