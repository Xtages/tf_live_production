data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["137112412989"] # AWS

  filter {
    name   = "name"
    values = ["amzn2-ami-minimal-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jumphost" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  # the VPC subnet
  subnet_id = element(var.public_subnets, 0)

  # the security group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # the public SSH key
  key_name = aws_key_pair.xtages_key.key_name

  tags = {
    Name         = "jumphost-${var.env}"
    Environmnent = var.env
  }
}

resource "aws_security_group" "allow_ssh" {
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

