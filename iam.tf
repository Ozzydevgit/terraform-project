# Define the IAM policy
resource "aws_iam_policy" "imagebuilder_policy" {
  name        = "ImageBuilderPolicy"
  description = "Policy for ImageBuilder with ECR and other necessary permissions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "imagebuilder:GetComponent",
          "imagebuilder:GetContainerRecipe",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:ListImages",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:PutImage"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "kms:Decrypt",
        Resource = "*",
        Condition = {
          "ForAnyValue:StringEquals": {
            "kms:EncryptionContextKeys": "aws:imagebuilder:arn",
            "aws:CalledVia": "imagebuilder.amazonaws.com"
          }
        }
      },
      {
        Effect = "Allow",
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::ec2imagebuilder*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:log-group:/aws/imagebuilder/*"
      }
    ]
  })
}

# Define the IAM role
resource "aws_iam_role" "imagebuilder_role" {
  name               = "ImageBuilderRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "imagebuilder_role_policy_attachment" {
  policy_arn = aws_iam_policy.imagebuilder_policy.arn
  role       = aws_iam_role.imagebuilder_role.name
}

# Create an instance profile for the IAM role
resource "aws_iam_instance_profile" "main" {
  name = "dev_profile"
  role = aws_iam_role.imagebuilder_role.name
}

# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_instance_profile" "main" {
#   name = "dev_profile"
#   role = aws_iam_role.role.name
# }