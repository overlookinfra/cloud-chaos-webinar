## BEGIN PROVIDER DETAILS ##
provider "aws" {
  version = "~> 2.0"
  region  = "us-west-1"
  profile = "default"
}
## END PROVIDER DETAILS

data "aws_ami" "your_ami" {
  owners      = ["owneracct#"]
  most_recent = true

  filter {
    name = "name"
    values = ["PuppetCentos7"]
  }
}
data "template_file" "init" {
    template = file("./userdata/userdata.tpl")
    count = "${var.howmany}"
    vars = {
        pp_environment = var.environment
        pp_datacenter  = "aws-${var.region}"
        pp_role        = "role::development_server"
        pe_server      = var.pe_server
    }
}

## END DATA SOURCES

## BEGIN RESOURCE DEFINITIONS
resource "aws_instance" "ec2_instance" {
  count                       = var.howmany
  ami                         = data.aws_ami.centos_7.id
  instance_type               = "t3.micro"
  associate_public_ip_address = "true"
  subnet_id                   = "subnet-12345"
  vpc_security_group_ids      = ["sg-12345"]
  key_name                    = "yourkey"
  user_data                   = "${element(data.template_file.init.*.rendered, count.index + 1)}"
}







## END RESOURCE DEFINITIONS ##

## BEGIN OUTPUTS ##
output "ec2_dns" {
    value = aws_instance.ec2_instance.*.public_dns
}
## END OUTPUTS
