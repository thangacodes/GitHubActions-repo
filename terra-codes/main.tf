data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.vm_spec
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    encrypted = true
  }
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = false
    encrypted             = true
  }
  key_name               = var.sshkey
  vpc_security_group_ids = [var.virtualfirewall]
  tags                   = merge(var.tagging, { Name = "SimpleWebApp" })
}
