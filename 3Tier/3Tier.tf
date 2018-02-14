# 3 Tier APP

variable "C1_Downlink"          {}
variable "C1_SG_id"             {}
variable "C1_RDS_1b"            {}
variable "C1_RDS_1c"            {}

variable "key_pair"             {}
variable "Web_AMI"              {}
variable "App_AMI"              {}

variable "DBname"               {}
variable "DBuser"               {}
variable "DBpass"               {}
variable "web_count"            {}
variable "C1_base_ip"           {}



/*================
EC2 Instance for Web host
This is a mix between "aws_network_interface" and "aws_instance" to be able to tag the Eth0 interface
=================*/

resource "aws_network_interface" "WebEth0" {
    count = "${var.web_count}"
    subnet_id       = "${var.C1_Downlink}"
    security_groups = ["${var.C1_SG_id}"]
    private_ips     = ["${cidrhost(var.C1_base_ip, count.index + 10)}"]
    tags = {
      "nsx:network" = "default"
    }  
}
resource "aws_instance" "web" {
    count = "${var.web_count}"
    ami                         = "${var.Web_AMI}"
    instance_type               = "t2.micro"
    network_interface {
     network_interface_id       = "${element(aws_network_interface.WebEth0.*.id, count.index)}"
     device_index               = 0
    } 
    key_name                    = "${var.key_pair}"
    user_data = "${file("${path.module}/user-data-web.tpl")}"
    
    tags = {
        Name = "GC-3Tier-Web-${count.index + 1}"
    }
}


/*================
EC2 Instance for App host
This is a mix between "aws_network_interface" and "aws_instance" to be able to tag the Eth0 interface
=================*/
resource "aws_network_interface" "AppEth0" {
    subnet_id       = "${var.C1_Downlink}"
    security_groups = ["${var.C1_SG_id}"]
    private_ips     = ["${cidrhost(var.C1_base_ip, 20)}"]
    tags = {
      "nsx:network" = "default"
    }  
}
resource "aws_instance" "app" {
    ami                         = "${var.App_AMI}"
    instance_type               = "t2.micro"
    network_interface {
     network_interface_id       = "${aws_network_interface.AppEth0.id}"
     device_index               = 0
    } 
    key_name                    = "${var.key_pair}"    
    tags = {
        Name = "GC-3Tier-App VM"
    }
}

/*================
RDS Instance
=================*/

#Create subnet group

resource "aws_db_subnet_group" "C1_db_subnet_grp" {
    subnet_ids = ["${var.C1_RDS_1b}", "${var.C1_RDS_1c}"]

  tags {
    Name = "C1_DB subnet group"
  }
}


resource "aws_db_instance" "DB" {
    allocated_storage       = 5
    engine                  = "MySQL"
    engine_version          = "5.6.35"
    instance_class          = "db.t2.micro"
    name                    = "CorpDB"
    identifier              = "corpdb"
    username                = "${var.DBuser}"
    password                = "${var.DBpass}"
    skip_final_snapshot     = true
    db_subnet_group_name    = "${aws_db_subnet_group.C1_db_subnet_grp.id}"
    vpc_security_group_ids  = ["${var.C1_SG_id}"]
  tags {
    Name = "3Tier-DB"
  }
}

/*================
Elastic Load Balancer for our Web instances
=================*/

resource "aws_elb" "ELB_web" {
  name              = "ELB-web"
  subnets           = ["${var.C1_Downlink}"]
  security_groups   = ["${var.C1_SG_id}"]
  

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/healthy.html"
    interval            = 10
  }

  # The instances are registered automatically

  instances                   = ["${aws_instance.web.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
    
  tags {
    Name = "Web Servers ELB"
  }
}

output "DBuser"                 {value = "${aws_db_instance.DB.username}"}
output "DBpass"                 {value = "${aws_db_instance.DB.password}"}
output "rds_instance_address"   {value = "${aws_db_instance.DB.address}"}

output "appVM_IP"               {value = "${aws_instance.app.public_ip}"}
output "webVM_IPs"              {value = ["${aws_instance.web.*.public_ip}"]}

output "ELB_dns_name"           {value = "${aws_elb.ELB_web.dns_name}"}  
output "ELB_zone_id"            {value = "${aws_elb.ELB_web.zone_id}"} 
output "web_count"              {value = "${var.web_count}"}
