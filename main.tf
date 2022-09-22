locals {
  ami_id = "ami-09e67e426f25ce0d7"
  vpc_id = "vpc-04a9948fc461b1052"
  ssh_user = "ubuntu"
  key_name = "Demokey"
  private_key_path = "/home/labsuser/Demokey.pem"
}

provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAVSUEUSV4FVFIL6HL"
  secret_key = "V6GRH1uIrhtDBuaH6MOXb+yytYyaqjrI7YVg72fS"
  token = "FwoGZXIvYXdzENz//////////wEaDBy1jNzrLm5vbygp4iK0AeJWFZxjjhurdHXLgaSCNHUWPgTG8z1BYiH2Hr5r3/QcRbp04WzvygFByC6iObaX76JCvfA9yueweplvahca2rMfa4GlTjuWYO3Hz6Nh3SX7BrGmnmemsHTgCeqCI6cy7GvZSYXi1e4UNFpXDzwPgtPJpmXrLpkIqo76U5/FY+MlxecchdBIRc7dyoJh7oKCUSVBNI78h2I0Qhm7LpnGGQdCHnqZcCAxL6lpbn6lKjqtVsMpUCiQ16uZBjItNVGZWMj8YUXd2BeTyStPgDegZHhaqcq4Kk1QOSWsnwd9cFreFoHOECOfFT4j"
}

resource "aws_security_group" "demoaccess" {
	name   = "demoaccess"
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
  vpc_security_group_ids =[aws_security_group.demoaccess.id]
  key_name = local.key_name

  tags = {
    Name = "Demo ec2"
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

