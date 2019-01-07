#ECS Prod Cluster
resource "aws_ecs_cluster" "prod_cluster" {
  name = "prod-cluster"
}

#ECS Web Task Definition
resource "aws_ecs_task_definition" "web" {
  family                = "service"
  container_definitions = "${file("../../modules/compute/files/task-definitions/web.json")}"

}

resource "aws_ecs_service" "web" {
  name            = "web"
  cluster         = "${aws_ecs_cluster.prod_cluster.id}"
  task_definition = "${aws_ecs_task_definition.web.arn}"
  desired_count   = 2

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  network_configuration {
    subnets = ["${var.private_subnets}"]

  }
}

resource 


