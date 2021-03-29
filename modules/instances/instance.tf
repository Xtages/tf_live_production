data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.latest_ecs.id
  instance_type = var.instance_type

  # the VPC subnet
  subnet_id = element(var.public_subnets, 0)

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.xtages_key.key_name

  tags = {
    Name         = "instance-${var.env}"
    Environmnent = var.env
  }
}

resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.vpc_id
  name        = "allow-ssh-${var.env}"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.env
  }
}

resource "aws_key_pair" "xtages_key" {
  key_name   = "xtages-${var.env}"
  public_key = file("${path.module}/${var.ssh_pub_key_name}")
}

