#ECS Prod Cluster
resource "aws_ecs_cluster" "prod_cluster" {
  name = "prod-cluster"
}

#ECS Web Task Definition
resource "aws_ecs_task_definition" "web" {
  family                = "service"
  container_definitions = "${file("../../modules/compute/files/task-definitions/web.json")}"
  
  network_mode = "bridge"
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

###############
#ECS ASG Block#
###############

#ECS AMI
data "aws_ami" "ecs_server_ami" {
  filter {
    name   = "image-id"
    values = ["${var.ecs_ami_id}"]
  }
}


resource "aws_launch_configuration" "ecs_as_conf" {
  image_id             = "${data.aws_ami.ecs_server_ami.id}"
  instance_type        = "t2.medium"
  key_name             = "kops-ssh-key"
  user_data            = "${file("../../modules/compute/files/ecs-user-data.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-profile.name}"
  security_groups      = ["${aws_security_group.ecs_server.id}", "${aws_security_group.consul_agent.id}"]
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "ecs_as_group" {
  vpc_zone_identifier       = ["${var.private_subnets}"]
  name                      = "${var.ecs_asg_name} ASG"
  min_size                  = 1
  max_size                  = 5
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.ecs_as_conf.name}"
  lifecycle { create_before_destroy = true }
}

############
#ECS Role  #
###########

resource "aws_iam_role" "ecs-role" {
  name = "ecs-role"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
}
EOF
}

resource "aws_iam_policy" "ecs-policy" {
  name        = "ecs-policy"
  description = "ECS Policy for describing instances."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-attach" {
  role       = "${aws_iam_role.ecs-role.name}"
  policy_arn = "${aws_iam_policy.ecs-policy.arn}"
}

resource "aws_iam_instance_profile" "ecs-profile" {
  name = "ecs-profile"
  role = "${aws_iam_role.ecs-role.name}"
}
