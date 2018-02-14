#Routes tables

variable "Cmpt1_vpc_id"             {}     
variable "Cmpt1_vpc_cidr"           {}       
variable "Cmpt1_igw_id"             {}
variable "Cmpt1_RT"                 {}
variable "C1_Downlink"              {}
variable "C1_Mgmt"                  {}
variable "C1_Uplink"                {} 

variable "Cmpt2_vpc_id"             {}     
variable "Cmpt2_vpc_cidr"           {}
variable "Cmpt2_igw_id"             {}
variable "Cmpt2_RT"                 {}
variable "C2_Downlink"              {}
variable "C2_Mgmt"                  {}
variable "C2_Uplink"                {} 

variable "PeerID"                   {}



/*================
Default Route for Compute1 and 2 using IGW
=================*/
resource "aws_route" "compute1-default-route" {
    route_table_id              = "${var.Cmpt1_RT}"
    destination_cidr_block      = "0.0.0.0/0"
    gateway_id                  = "${var.Cmpt1_igw_id}"
}

resource "aws_route" "compute2-default-route" {
    route_table_id              = "${var.Cmpt2_RT}"
    destination_cidr_block      = "0.0.0.0/0"
    gateway_id                  = "${var.Cmpt2_igw_id}"
}

/*================
Route Table association
=================*/
resource "aws_route_table_association" "C1_10" {
    subnet_id      = "${var.C1_Downlink}"
    route_table_id = "${var.Cmpt1_RT}"
}
resource "aws_route_table_association" "C1_20" {
    subnet_id      = "${var.C1_Mgmt}"
    route_table_id = "${var.Cmpt1_RT}"
}
resource "aws_route_table_association" "C1_30" {
    subnet_id      = "${var.C1_Uplink}"
    route_table_id = "${var.Cmpt1_RT}"
}

resource "aws_route_table_association" "C2_10" {
    subnet_id      = "${var.C2_Downlink}"
    route_table_id = "${var.Cmpt2_RT}"
}
resource "aws_route_table_association" "C2_20" {
    subnet_id      = "${var.C2_Mgmt}"
    route_table_id = "${var.Cmpt2_RT}"
}
resource "aws_route_table_association" "C2_30" {
    subnet_id      = "${var.C2_Uplink}"
    route_table_id = "${var.Cmpt2_RT}"
}


/*================
Route for  VPC C1 to C2 and back  using VPC Peering
=================*/
resource "aws_route" "compute2-to-1" {
    route_table_id              = "${var.Cmpt2_RT}"
    destination_cidr_block      = "${var.Cmpt1_vpc_cidr}"
    vpc_peering_connection_id   = "${var.PeerID}"
}
resource "aws_route" "compute1-to-2" {
    route_table_id              = "${var.Cmpt1_RT}"
    destination_cidr_block      = "${var.Cmpt2_vpc_cidr}"
    vpc_peering_connection_id   = "${var.PeerID}"
}