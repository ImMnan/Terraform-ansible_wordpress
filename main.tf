locals {
  ami_id = "ami-09e67e426f25ce0d7"
  vpc_id = "vpc-01b7844d367765b11"
  ssh_user = "ubuntu"
  key_name = "wpkey"
  private_key_path = "/home/labsuser/wpkey.pem"
}

provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAVSUEUSV4NRO32M2X"
  secret_key = "HJo+iPpdITfttFjsSkl8kKHrMY+9ganEHNMCIhFo"
  token = "FwoGZXIvYXdzEO3//////////wEaDLuiwxaQ4DxkZ4HK2iK0ATs2lcDG60oTOOs41tQ158PHb6hK3igCLTWZimtHwQn1C71Igph9rt9z0s5OKeoUT/VEp2IUa5SKe/KAc0T720PbOqT02WgFkT1zxpgXBxIJ3f35kVlVlpdpeUP3qNnPAkeU4AZAE6Rm5CCZdTAhfR4e2piLnLwQUwTL5nTiEZcS3bkF+wmQOBiJCCUS6Hsj8wODYsiDYEIUxHDx24Yx5ylM55mYYVNXfBsKPDFZBofpVSQb+CjWrq+ZBjItWoMRM/NigHN4c8yWv4Ms0cFNtxWtVaJroWvsjefRDAvffJFCUma23yEBp/cE"
}

resource "aws_security_group" "wpaccess" {
	name   = "wpaccess"
	vpc_id = local.vpc_id
    
  ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
  ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

  ingress {
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

  egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "web" {
  ami = local.ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  vpc_security_group_ids =[aws_security_group.wpaccess.id]
  key_name = local.key_name

  tags = {
    Name = "wp ec2"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = local.ssh_user
    private_key = file(local.private_key_path)
    timeout = "4m"
  }

  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > myhosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i myhosts --user ${local.ssh_user} --private-key ${local.private_key_path} initiate.yaml"
  }

}

output "instance_ip" {
  value = aws_instance.web.public_ip
}

