/*================
Creating  multiple Security Groups
=================*/

variable "Cmpt1_vpc_id"          {}
variable "Cmpt2_vpc_id"          {}
variable "compute1_cidr"         {}
variable "compute2_cidr"         {}


/*================
Security Group NSX Compute1 and 2
=================*/
resource "aws_security_group" "nsx_compute1_sg" {
  name = "nsx-compute1-security-group"
  description = "Security Group for NSX-Compute1 Resources"
  vpc_id = "${var.Cmpt1_vpc_id}"
  tags = {
       Name = "C1_default_sg"
  }
  #all open
  ingress = {
       from_port = 0
       to_port = 0
       protocol = -1
       cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {

      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nsx_compute2_sg" {
  name = "nsx-compute2-security-group"
  description = "Security Group for NSX-Compute2 Resources"
  vpc_id = "${var.Cmpt2_vpc_id}"
  tags = {
    Name = "C2_Default_sg"
  }
  #all open
  ingress = {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {

    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}



/*================
Outputs variables for other modules to use
=================*/
#Security Groups IDs
output "C1_SG_id"      { value = "${aws_security_group.nsx_compute1_sg.id}" }
output "C2_SG_id"      { value = "${aws_security_group.nsx_compute2_sg.id}" }
