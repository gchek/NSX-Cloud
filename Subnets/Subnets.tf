/*================
Create Management and Compute subnets 
All IP ranges are in one file: variables.tf
=================*/

variable "Cmpt1_vpc_id"             {}
variable "C1_Downlink_cidr_1b"      {}
variable "C1_Mgmt_cidr_1b"          {}
variable "C1_Uplink_cidr_1b"        {}
variable "C1_RDS_cidr_1b"           {}
variable "C1_RDS_cidr_1c"           {}

variable "Cmpt2_vpc_id"             {}
variable "C2_Downlink_cidr_1b"      {}
variable "C2_Mgmt_cidr_1b"          {}
variable "C2_Uplink_cidr_1b"        {}
variable "C2_RDS_cidr_1b"           {}
variable "C2_RDS_cidr_1c"           {}

# Get Availability zones in the Region
data "aws_availability_zones" "AZ" {}


/*================
Create Compute1 Downlink subnet 
=================*/
resource "aws_subnet" "C1_Downlink" {
    vpc_id = "${var.Cmpt1_vpc_id}"
    cidr_block = "${var.C1_Downlink_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C1_DownLink_subnet"
    }
}

/*================
Create Compute1 Management subnet 
=================*/
resource "aws_subnet" "C1_Mgmt" {
    vpc_id = "${var.Cmpt1_vpc_id}"
    cidr_block = "${var.C1_Mgmt_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C1_Mgmt_subnet"
    }
}

/*================
Create Compute1 UP link subnet 
=================*/
resource "aws_subnet" "C1_Uplink" {
    vpc_id = "${var.Cmpt1_vpc_id}"
    cidr_block = "${var.C1_Uplink_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C1_Up_link_subnet"
    }

}

/*================
Create RDS subnet 1
=================*/
resource "aws_subnet" "C1_RDS_1b" {
    vpc_id = "${var.Cmpt1_vpc_id}"
    cidr_block = "${var.C1_RDS_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C1_RDS DB subnet1"
    }

}
/*================
Create RDS subnet 2
=================*/
resource "aws_subnet" "C1_RDS_1c" {
    vpc_id = "${var.Cmpt1_vpc_id}"
    cidr_block = "${var.C1_RDS_cidr_1c}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[1]}"
    tags = {
        Name = "C1_RDS DB subnet2"
    }

}

/*================
Create Compute2 Downlink subnet 
=================*/
resource "aws_subnet" "C2_Downlink" {
    vpc_id = "${var.Cmpt2_vpc_id}"
    cidr_block = "${var.C2_Downlink_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C2_DownLink_subnet"
    }
}

/*================
Create Compute2 Management subnet 
=================*/
resource "aws_subnet" "C2_Mgmt" {
    vpc_id = "${var.Cmpt2_vpc_id}"
    cidr_block = "${var.C2_Mgmt_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C2_Mgmt_subnet"
    }
}

/*================
Create Compute2 UP link subnet 
=================*/
resource "aws_subnet" "C2_Uplink" {
    vpc_id = "${var.Cmpt2_vpc_id}"
    cidr_block = "${var.C2_Uplink_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C2_Up_link_subnet"
    }

}

/*================
Create C2_RDS subnet 1
=================*/
resource "aws_subnet" "C2_RDS_1b" {
    vpc_id = "${var.Cmpt2_vpc_id}"
    cidr_block = "${var.C2_RDS_cidr_1b}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[0]}"
    tags = {
        Name = "C2_RDS DB subnet1"
    }

}
/*================
Create C2_RDS subnet 2
=================*/
resource "aws_subnet" "C2_RDS_1c" {
    vpc_id = "${var.Cmpt2_vpc_id}"
    cidr_block = "${var.C2_RDS_cidr_1c}"
    map_public_ip_on_launch = true 
    availability_zone = "${data.aws_availability_zones.AZ.names[1]}"
    tags = {
        Name = "C2_RDS DB subnet2"
    }

}
/*================
Outputs variables for other modules to use
=================*/
#Subnets IDs
output "C1_Downlink"    { value = "${aws_subnet.C1_Downlink.id}" }
output "C1_Mgmt"        { value = "${aws_subnet.C1_Mgmt.id}" }
output "C1_Uplink"      { value = "${aws_subnet.C1_Uplink.id}" }
output "C1_RDS_1b"      { value = "${aws_subnet.C1_RDS_1b.id}" }
output "C1_RDS_1c"      { value = "${aws_subnet.C1_RDS_1c.id}" }

output "C2_Downlink"    { value = "${aws_subnet.C2_Downlink.id}" }
output "C2_Mgmt"        { value = "${aws_subnet.C2_Mgmt.id}" }
output "C2_Uplink"      { value = "${aws_subnet.C2_Uplink.id}" }
output "C2_RDS_1b"      { value = "${aws_subnet.C2_RDS_1b.id}" }
output "C2_RDS_1c"      { value = "${aws_subnet.C2_RDS_1c.id}" }


