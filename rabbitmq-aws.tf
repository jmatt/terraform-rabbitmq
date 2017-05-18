# Use AWS.
provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "rabbit_lsst-keypair" {
  key_name   = "rabbit_lsst-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkVJJH7jBXvdnE+YE+4twX7Zi994duvZPu8JyGpduxEMVum3NwQy7XR+RArNtiMyxlNHw6dt9lifRNAPdnuqo/z+xcSsn1Gu8t3JDeL8SE4iFKg+S0gDLpYFLzT8wjt1nPe47qMfcHJaJ/WHvR0fRsLrUzrzUV0N2gmDhTN9wId0Xz9ZoTFtlCi8stYvYTGL42Fc1cwmjd/gfGzWJPU3/VNuW/oM/eezQCfyz0K8cp7BmBWkQjTdn82ARFzdUk26lFjM7wG5pX3wbceqO4vQOzYnWTS/BlQ7sflBD6VSlWZjuSTINlJX5fSkue0Tnc+xNXgOp3s9SQbhoRj4TrNJr6Hn7X4JLGpeb+Y/HRUIpbq8yWsXfj6sPl95YNdAbDww2EiGanUi7JfQt1ws0XcHbGxVDkOEN6bYW/4BWBEmjYyxB1d0JCr+ZZ9meZL461gaFgrJnlgKAzxnXPRksPjVps/Ih+CVsS1WCZaKokjboGXp1u5JdW54j+8GQyMoxB9pBlmXXGSYfIDdVXehF/GKsJvWoNZKvE5p47jlkY3lRUqAzHtTDcNXnfwDZkrW3ib6ILvmfzptDQbOPzuccKkFYXbTuJux3dkKNWJbE3VOjIDv1OcHr2yNv1EYE3kuC9P9q9jgjszwa9dfZz4gtq4bMeZuW1814f4BkyoaqHpT+llw== jmatt@lsst.org"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name  = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "rabbit_aws_shovel" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "rabbit_lsst-key"
  tags {
    Name = "RabbitMQ"
  }

  security_groups = [
    "${aws_security_group.rabbitmq_allow_ssh.name}",
    "${aws_security_group.rabbitmq_allow_egress.name}",
    "${aws_security_group.rabbitmq_allow_local.name}"
  ]
}

resource "aws_security_group" "rabbitmq_allow_ssh" {
  name        = "rabbitmq_allow_ssh"
  description = "Allow ssh traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rabbitmq_allow_shovel" {
  name        = "rabbitmq_allow_shovel"
  description = "Allow shovel traffic"

  ingress {
    from_port   = 5671
    to_port     = 5672
    protocol    = "TCP"
    cidr_blocks = ["141.142.0.0/16"]
  }

  egress {
    from_port       = 5671
    to_port         = 5672
    protocol        = "TCP"
    cidr_blocks     = ["141.142.0.0/16"]
  }
}

resource "aws_security_group" "rabbitmq_allow_egress" {
  name        = "rabbitmq_allow_egress"
  description = "Allow outbound traffic"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# resource "aws_vpc" "rabbitmq_vpc" {
#   cidr_block = "10.1.42.0/24"

#   tags {
#     Name = "RabbitMQ"
#   }
# }

resource "aws_security_group" "rabbitmq_allow_rabbitmq" {
  name        = "rabbitmq_allow_rabbitmq"
  description = "Allow rabbitmq egress traffic."

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "TCP"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rabbitmq_allow_local" {
  name        = "rabbitmq_allow_local"
  description = "Allow rabbitmq local traffic."

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["127.0.0.1/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = ["127.0.0.1/32"]
  }
}
