/*================
To preserve the AWS Credentials, 
the keys are only in one file (terraform.tfvars) and
should not appear anywhere else
=================*/
provider "aws" {
    access_key  = "${var.access_key}"
    secret_key  = "${var.secret_key}"
    region      = "${var.region}"
}
/*================
The VPC IP range is set in "Variables.tf" file
=================*/
module "VPCs" {
    source = "../VPCs"

    compute1_cidr           = "${var.My_subnets["compute1"]}"
    compute2_cidr           = "${var.My_subnets["compute2"]}"

    
}
/*================
In the Subnet module we create the relevant subnetting for our lab and again
The IP range is set in "Variables.tf" file.
We use outputs from the VPC module for passing the VPC IDs
=================*/
module "Subnets" {
    source = "../Subnets" 
    Cmpt1_vpc_id               = "${module.VPCs.Cmpt1_vpc_id}"
    C1_Downlink_cidr_1b        = "${var.My_subnets["C1_Downlink_1b"]}" 
    C1_Mgmt_cidr_1b            = "${var.My_subnets["C1_Mgmt_1b"]}"
    C1_Uplink_cidr_1b          = "${var.My_subnets["C1_Uplink_1b"]}"
    C1_RDS_cidr_1b             = "${var.My_subnets["C1_RDSnet_1b"]}"
    C1_RDS_cidr_1c             = "${var.My_subnets["C1_RDSnet_1c"]}"

    Cmpt2_vpc_id               = "${module.VPCs.Cmpt2_vpc_id}"
    C2_Downlink_cidr_1b        = "${var.My_subnets["C2_Downlink_1b"]}" 
    C2_Mgmt_cidr_1b            = "${var.My_subnets["C2_Mgmt_1b"]}"
    C2_Uplink_cidr_1b          = "${var.My_subnets["C2_Uplink_1b"]}"
    C2_RDS_cidr_1b             = "${var.My_subnets["C2_RDSnet_1b"]}"
    C2_RDS_cidr_1c             = "${var.My_subnets["C2_RDSnet_1c"]}"     
    
}


/*================
In the Route module we create the relevant route tables for our lab.
We use outputs from the VPC module for passing multiple parameters:
the VPC IDs - VPC CIDRs - VPC peer ID - IGW IDs - VPCs main route tables
=================*/
module "Routes" {
    source = "../Routes"
    #outputs from VPC and subnet module
    Cmpt1_vpc_id            = "${module.VPCs.Cmpt1_vpc_id}"
    Cmpt1_vpc_cidr          = "${module.VPCs.Cmpt1_vpc_cidr}"
    Cmpt1_igw_id            = "${module.VPCs.Cmpt1_igw_id}"
    Cmpt1_RT                = "${module.VPCs.Cmpt1_RT}"
    C1_Downlink             = "${module.Subnets.C1_Downlink}" 
    C1_Mgmt                 = "${module.Subnets.C1_Mgmt}" 
    C1_Uplink               = "${module.Subnets.C1_Uplink}" 

    Cmpt2_vpc_id            = "${module.VPCs.Cmpt2_vpc_id}"
    Cmpt2_vpc_cidr          = "${module.VPCs.Cmpt2_vpc_cidr}"
    Cmpt2_igw_id            = "${module.VPCs.Cmpt2_igw_id}"
    Cmpt2_RT                = "${module.VPCs.Cmpt2_RT}"
    C2_Downlink             = "${module.Subnets.C2_Downlink}" 
    C2_Mgmt                 = "${module.Subnets.C2_Mgmt}" 
    C2_Uplink               = "${module.Subnets.C2_Uplink}" 

    PeerID                  = "${module.VPCs.PeerID}"

}

/*================
In the Security Groug module we create the necessary SGs for our lab.
We use outputs from the VPC module for passing the VPC IDs
=================*/
module "SGs" {
    source = "../SGs"
    Cmpt1_vpc_id         = "${module.VPCs.Cmpt1_vpc_id}"
    Cmpt2_vpc_id         = "${module.VPCs.Cmpt2_vpc_id}"
    compute1_cidr        = "${var.My_subnets["compute1"]}"
    compute2_cidr        = "${var.My_subnets["compute2"]}"
}

/*================
In the EC2 module we will deploy Jump Hosts instances
We use outputs from the Subnets and SG modules for passing the Subnets IDs
=================*/
module "EC2" {
    source = "../EC2"
    
    C1_Downlink         = "${module.Subnets.C1_Downlink}"
    C2_Downlink         = "${module.Subnets.C2_Downlink}"
    C1_base_ip          = "${var.My_subnets["C1_Downlink_1b"]}"
    C2_base_ip          = "${var.My_subnets["C2_Downlink_1b"]}"
    C1_SG_id            = "${module.SGs.C1_SG_id}"
    C2_SG_id            = "${module.SGs.C2_SG_id}"


    key_pair            = "${lookup(var.key_pair, var.region)}"
    JumpHost_AMI        = "${lookup(var.JH_AMI, var.region)}"

}


/*================
In the 3Tier App module we will deploy Web-App-DB instances
We use outputs from the Subnets and SG modules for passing the Subnets IDs
=================*/
module "3Tier" {
    source = "../3Tier"
   
    C1_Downlink             = "${module.Subnets.C1_Downlink}"
    C1_SG_id                = "${module.SGs.C1_SG_id}"
    C1_base_ip              = "${var.My_subnets["C1_Downlink_1b"]}"
    web_count               = "${var.web_count}"
    C1_RDS_1b               = "${module.Subnets.C1_RDS_1b}"
    C1_RDS_1c               = "${module.Subnets.C1_RDS_1c}" 

    key_pair                = "${lookup(var.key_pair, var.region)}"
    Web_AMI                 = "${lookup(var.Web_AMI, var.region)}"
    App_AMI                 = "${lookup(var.App_AMI, var.region)}"

    DBname                  = "${var.DBname}"
    DBuser                  = "${var.DBuser}" 
    DBpass                  = "${var.DBpass}"

}

/*================
vRNI User and policies
=================*/
module "vRNI" {
    source = "../vRNI"
   
    Cmpt1_vpc_id             = "${module.VPCs.Cmpt1_vpc_id}"
}



