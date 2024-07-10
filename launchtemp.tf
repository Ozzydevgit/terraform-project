resource "aws_launch_template" "main" {
    name = "${var.name}-launch-template"
    description = "Lauch template"
    image_id = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    key_name = "dev"
    user_data = filebase64("bootstrap.sh")
    update_default_version = true
    vpc_security_group_ids = [aws_security_group.allow_http.id]
}



