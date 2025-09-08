resource "aws_launch_template" "main" {
    name = "${var.name}-launch-template"
    description = "Lauch template"
    image_id = "ami-08f9a9c699d2ab3f9" #"ami-03fd334507439f4d1"
    instance_type = "t2.micro"
    key_name = "dev"
    user_data = filebase64("bootstrap.sh")
    update_default_version = true
    vpc_security_group_ids = [aws_security_group.allow_http.id]
    iam_instance_profile {
        name = aws_iam_instance_profile.main.name
      }
}



