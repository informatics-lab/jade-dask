resource "aws_efs_file_system" "jade_notebooks" {
  tags {
    Name = "jade-notebooks"
  }
}