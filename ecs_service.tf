data "aws_ecs_cluster" "runner_cluster" {
  cluster_name = var.ecs_cluster
}

# resource "aws_ecs_service" "github-runner" {
#   name            = "github-runners-${var.namespace}"
#   cluster         = data.aws_ecs_cluster.runner_cluster.id
#   task_definition = aws_ecs_task_definition.runner_task_definition.arn
#   desired_count   = var.desired_count

#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.region in [${data.aws_region.current.name}]"
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.subnet in [${join(",", var.subnets)}]"
#   }
# }
