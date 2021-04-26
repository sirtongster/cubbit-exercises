resource "aws_ecr_repository" "cubbit_ecr" {
  name                 = "${var.project_name}-${var.env}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}