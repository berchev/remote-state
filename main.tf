terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "berchevorg-free"

    workspaces {
      name = "remote-state"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "example" {
  ami                    = "ami-40d28157"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  key_name = "us-east-1-key-pair"


  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "terraform_remote_state" "remote" {
  backend = "s3"

  config = {
    bucket = "berchev-terraform-book-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}
