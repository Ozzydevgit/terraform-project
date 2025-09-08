provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16" // make it a variable
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

 