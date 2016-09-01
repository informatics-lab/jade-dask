resource "aws_efs_file_system" "jadenotebooks" {
  tags {
    Name = "jade-notebooks"
  }
}