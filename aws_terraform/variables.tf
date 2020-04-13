variable "project_key" {
  description = "Project Name"
  type        = string

  default = "a4b"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string

  default = "user1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string

  default = "10.0.0.0/16"
}

variable "vpc_subnet" {
  description = "Subnet settings"
  type        = map(map(string))

  default = {
    public-a = {
      cidr  = "10.0.0.0/24"
      route = "igw"
    }
    public-c = {
      cidr  = "10.0.1.0/24"
      route = "igw"
    }
    private-a = {
      cidr  = "10.0.2.0/24"
      route = "private"
    }
    private-c = {
      cidr  = "10.0.3.0/24"
      route = "private"
    }
  }
}

variable "my_ip" {
  description = "My IP Address"
  type        = string
}