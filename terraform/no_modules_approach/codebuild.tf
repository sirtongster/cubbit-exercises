resource "aws_s3_bucket" "cubbit_s3" {
  bucket = "${var.project_name}-${var.env}-s3-example"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_example_role" {
  name = "TESTCodebuildRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_example_policy" {
  role = aws_iam_role.codebuild_example_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": [
        "arn:aws:ec2:us-east-1:123456789012:network-interface/*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:Subnet": [
            "${aws_subnet.cubbit_sn1.arn}",
            "${aws_subnet.cubbit_sn2.arn}"
          ],
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.cubbit_s3.arn}",
        "${aws_s3_bucket.cubbit_s3.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "cubbit_codebuild" {
  name          = "${var.project_name}-${var.env}-codebuild"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_example_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.cubbit_s3.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      value = var.access_key_id
    }

    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = var.secret_access_key
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cubbit_s3.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/sirtongster/examen_qubbit.git"
    git_clone_depth = 1
  }

  source_version = var.env

  vpc_config {
    vpc_id = aws_vpc.cubbit_vpc.id

    subnets = [
      aws_subnet.cubbit_sn1.id,
      aws_subnet.cubbit_sn2.id,
    ]

    security_group_ids = [
      aws_security_group.cubbit_sg1.id,
      aws_security_group.cubbit_sg2.id,
    ]
  }

  tags = {
    Environment = "${var.env}"
  }
}