resource "aws_vpc" "cubbit_vpc" {
  cidr_block = "10.24.0.0/16"

  tags = {
    Name = "${var.project_name}-${var.env}-vpc"
  }
}