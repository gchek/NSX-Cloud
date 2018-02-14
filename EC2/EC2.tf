# EC2 Jumphosts Config

variable "C1_Downlink"              {}
variable "C2_Downlink"              {}
variable "C1_base_ip"               {}
variable "C2_base_ip"               {}
variable "key_pair"                 {}

variable "C1_SG_id"                 {}
variable "C2_SG_id"                 {}
variable "JumpHost_AMI"             {}

/*================
Cloud-init file for Jump host
=================*/

data "template_file" "user_data_Cmpt_jump_host" {
  template = "${file("${path.module}/cloud-init-Cmpt-jump-host.tpl")}"
    vars {}
}



/*================
EC2 Instance for Compute1 Jump host
=================*/
resource "aws_instance" "Cmpt1_Jumphost" {
    ami                         = "${var.JumpHost_AMI}"
    subnet_id                   = "${var.C1_Downlink}"
    instance_type               = "t2.micro"
    associate_public_ip_address = "true"
    vpc_security_group_ids      = ["${var.C1_SG_id}"]
    private_ip                  = "${cidrhost(var.C1_base_ip, 250)}"
    key_name                    = "${var.key_pair}"
    source_dest_check           = false
    user_data                   = "${data.template_file.user_data_Cmpt_jump_host.rendered}"
    

    tags = {
        Name = "C1 Jumphost"
    }
}

/*================
EC2 Instance for Compute2 Jump host
=================*/
resource "aws_instance" "Cmpt2_Jumphost" {
    ami                         = "${var.JumpHost_AMI}"
    subnet_id                   = "${var.C2_Downlink}"
    instance_type               = "t2.micro"
    associate_public_ip_address = "true"
    vpc_security_group_ids      = ["${var.C2_SG_id}"]
    private_ip                  = "${cidrhost(var.C2_base_ip, 250)}"
    key_name                    = "${var.key_pair}"
    source_dest_check           = false
    user_data                   = "${data.template_file.user_data_Cmpt_jump_host.rendered}"


    tags = {
        Name = "C2 Jumphost"
    }
}

output "Cmpt1_Jumphost_ip"      {value = "${aws_instance.Cmpt1_Jumphost.public_ip}"}
output "Cmpt2_Jumphost_ip"      {value = "${aws_instance.Cmpt2_Jumphost.public_ip}"}
output "Key_pair"               {value = "${aws_instance.Cmpt1_Jumphost.key_name}"}


/*
data "aws_ami" "ec2-linux" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}
*/
