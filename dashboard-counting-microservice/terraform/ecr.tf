# ============================================================
# ECR Repositories - Where Docker images are stored
# ============================================================

resource "aws_ecr_repository" "dashboard" {
  name                 = "dashboard"
  image_tag_mutability = "MUTABLE"
  force_delete         = true # Allows terraform destroy to delete repo with images
}

resource "aws_ecr_repository" "counting" {
  name                 = "counting"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
