resource "aws_subnet" "cubbit_sn1" {
  vpc_id     = aws_vpc.cubbit_vpc.id
  cidr_block = var.sn1_cidr_block

  tags = {
    Name = "${var.project_name}-${var.env}-sn1"
  }
}

resource "aws_subnet" "cubbit_sn2" {
  vpc_id     = aws_vpc.cubbit_vpc.id
  cidr_block = var.sn2_cidr_block

  tags = {
    Name = "${var.project_name}-${var.env}-sn2"
  }
}