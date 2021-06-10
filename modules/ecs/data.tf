data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "ecs_user_data" {
  //  installing iptables to enable IAM roles for tasks
  // https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
  template = <<-EOF
              #!/bin/bash
              yum install -y iptables-services
              iptables --insert FORWARD 1 --in-interface docker+ --destination 169.254.169.254/32 --jump DROP
              echo 'ECS_CLUSTER=xtages-cluster' > /etc/ecs/ecs.config
              echo 'ECS_ENABLE_SPOT_INSTANCE_DRAINING=true' >> /etc/ecs/ecs.config
              echo 'ECS_ENABLE_TASK_IAM_ROLE=true' >> /etc/ecs/ecs.config
              iptables-save | tee /etc/sysconfig/iptables && systemctl enable --now iptables
              start ecs
              EOF
}
