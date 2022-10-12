## Providers AWS
provider "aws" {
  assume_role {
    role_arn = var.switch_role_arn
  }

  region = var.region
}

## Data
data "aws_vpc" "default" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "tag:Name"
    values = var.subnet_name
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

## Security Group
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = var.name
  description = "Security group for ${var.name}"
  vpc_id      = data.aws_vpc.default.id

  egress_rules = ["all-all"]

  tags = var.tags
}

## Chaves SSH
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "this" {
  key_name   = var.name
  public_key = tls_private_key.this.public_key_openssh

  tags = var.tags
}

## cloud-init
data "template_file" "user_data" {
  template = file("scripts/cloud-init.yaml")

  vars = {
    username       = var.username
    ssh_public_key = tls_private_key.this.public_key_openssh
  }
}

## EC2 IAM Role
resource "aws_iam_role" "ec2" {
  name = "ec2-role-${var.name}"

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

resource "aws_iam_role_policy_attachment" "ec2" {
  count      = length(var.policies)
  role       = aws_iam_role.ec2.name
  policy_arn = var.policies[count.index]
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ecs-profile-${var.name}"
  role = aws_iam_role.ec2.name
}

## EC2
module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  instance_count = var.instances_number

  name                        = var.name
  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = "t4g.nano"
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = aws_key_pair.this.key_name
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile        = aws_iam_instance_profile.ec2.name

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 8
    },
  ]

  tags = var.tags
}
