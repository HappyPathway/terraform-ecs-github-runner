resource "aws_ecs_cluster" "foo" {
  name = "test-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
