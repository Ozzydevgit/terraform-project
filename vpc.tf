resource "aws_vpc" "ozzydev" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ozzydev.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.ozzydev.id
  availability_zone = "us-east-1a"
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsubnet"
  }
}
resource "aws_subnet" "public-2" {
  vpc_id = aws_vpc.ozzydev.id
  availability_zone = "us-east-1b"
  cidr_block = "10.10.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "publicsubnet"
  }
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.ozzydev.id
  availability_zone = "us-east-1b"
  cidr_block = "10.10.2.0/24"

  tags = {
    Name = "privatesubnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ozzydev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "RT Public : for ozzydevroute"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}



resource "aws_instance" "ozzydev" {
  ami           = "ami-04b70fa74e45c3917"  # Change to your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "dev"
  vpc_security_group_ids = [aws_security_group.ozzydev.id]

  tags = {
    Name = "ozzydev-instance"
  }
}

# Create a new security group
resource "aws_security_group" "ozzydev" {
  name        = "ozzydev-security-group"
  description = "Security group for example purposes"
  vpc_id      = aws_vpc.ozzydev.id # Change to your VPC ID

  # Inbound rules
  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Allow SSH from anywhere (be cautious with this setting)
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  # Outbound rules
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"  # Allow all outbound traffic
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ozzydev-security-group"
  }
}
# Create an Application Load Balancer
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ozzydev.id]
  subnets            = [
    aws_subnet.public.id,
    aws_subnet.public-2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "my-load-balancer"
  }
}
# Create a Target Group
resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ozzydev.id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "my-target-group"
  }
}
# Create a Listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_instance" "ozzydev-2" {
  ami           = "ami-04b70fa74e45c3917"  # Change to your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-2.id
  key_name      = "dev"
  vpc_security_group_ids = [aws_security_group.ozzydev.id]

  tags = {
    Name = "ozzydev-instance-2"
  }
}