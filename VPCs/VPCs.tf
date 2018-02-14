
/*================
Create Management and Compute VPCs 
Create respective Internet Gateways
Create VPC Peering
Create route 53 entry
=================*/

variable "compute1_cidr"    {}
variable "compute2_cidr"    {}

/*================
needed for VPC peering 
=================*/
data "aws_caller_identity" "current" {}

/*================
Compute1 VPC 
=================*/
resource "aws_vpc" "nsx-compute1-vpc" {
    cidr_block = "${var.compute1_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
         Name = "NSX-Compute1-VPC"
    }
}

/*================
Compute2 VPC 
=================*/
resource "aws_vpc" "nsx-compute2-vpc" {
    cidr_block = "${var.compute2_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
         Name = "NSX-Compute2-VPC"
    }
}

/*================
Compute1 IGW
=================*/
resource "aws_internet_gateway" "nsx-compute1-igw" {
    vpc_id = "${aws_vpc.nsx-compute1-vpc.id}"
    tags {
        Name = "NSX-Compute1-VPC-IGW"
    }

}

/*================
Compute2 IGW
=================*/
resource "aws_internet_gateway" "nsx-compute2-igw" {
    vpc_id = "${aws_vpc.nsx-compute2-vpc.id}"
    tags {
        Name = "NSX-Compute2-VPC-IGW"
    }

}



/*================
VPC Peering C1 to C2
=================*/
resource "aws_vpc_peering_connection" "VPC_Peering_C1_C2" {
    #depends_on      = ["aws_vpc.nsx-core-vpc"]
    depends_on      = ["aws_vpc.nsx-compute2-vpc"]
    peer_owner_id   = "${data.aws_caller_identity.current.account_id}"
    peer_vpc_id     = "${aws_vpc.nsx-compute1-vpc.id}"
    vpc_id          = "${aws_vpc.nsx-compute2-vpc.id}"
    auto_accept = true
    tags {
        Name = "VPC Peering C1-C2 VPC"
    }
}


/*================
Outputs variables for other modules to use
=================*/
output "Cmpt1_vpc_id"       { value = "${aws_vpc.nsx-compute1-vpc.id}" }
output "Cmpt1_vpc_cidr"     { value = "${aws_vpc.nsx-compute1-vpc.cidr_block}" }
output "Cmpt1_igw_id"       { value = "${aws_internet_gateway.nsx-compute1-igw.id}" }
output "Cmpt1_RT"           { value = "${aws_vpc.nsx-compute1-vpc.main_route_table_id}"}

output "Cmpt2_vpc_id"       { value = "${aws_vpc.nsx-compute2-vpc.id}" }
output "Cmpt2_vpc_cidr"     { value = "${aws_vpc.nsx-compute2-vpc.cidr_block}" }
output "Cmpt2_igw_id"       { value = "${aws_internet_gateway.nsx-compute2-igw.id}" }
output "Cmpt2_RT"           { value = "${aws_vpc.nsx-compute2-vpc.main_route_table_id}"}

output "PeerID"             { value = "${aws_vpc_peering_connection.VPC_Peering_C1_C2.id}"}
