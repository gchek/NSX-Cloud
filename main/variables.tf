/*================
REGIONS map:
==================
us-east-1	    US East (N. Virginia)
us-east-2	    US East (Ohio)
us-west-1	    US West (N. California)
us-west-2	    US West (Oregon)
ca-central-1	Canada (Central)
eu-west-1	    EU (Ireland)
eu-central-1	EU (Frankfurt)
eu-west-2	    EU (London)
ap-northeast-1	Asia Pacific (Tokyo)
ap-northeast-2	Asia Pacific (Seoul)
ap-southeast-1	Asia Pacific (Singapore)
ap-southeast-2	Asia Pacific (Sydney)
ap-south-1	    Asia Pacific (Mumbai)
sa-east-1	    South America (São Paulo)
=================*/


/*================
AWS Credentials, region and Key-pair in that region
Data Base credentials
=================*/
variable "access_key"   {}
variable "secret_key"   {}
variable "region"       {}
variable "key_pair" {
    type = "map"
    default = {
        us-east-1 = "aws_key_us-east-1"
        us-west-1 = "aws_key_us-west-1"
    }
}


variable "DBname"       {}
variable "DBuser"       {}
variable "DBpass"       {}

variable "web_count"    {default = "3"} #how many web servers for front-end (max=4)




/*================
Subnets IP ranges
=================*/
variable "My_subnets" {
    type    = "map"
    default = {

        compute1                 = "172.16.0.0/16"
        C1_Downlink_1b           = "172.16.10.0/24"
        C1_Downlink_1c           = "172.16.11.0/24"
        C1_Mgmt_1b               = "172.16.20.0/24"
        C1_Mgmt_1c               = "172.16.21.0/24"
        C1_Uplink_1b             = "172.16.30.0/24"
        C1_Uplink_1c             = "172.16.31.0/24"
        C1_RDSnet_1b             = "172.16.40.0/28" #reduce span for IPSets /28 is min in AWS
        C1_RDSnet_1c             = "172.16.41.0/28" #reduce span for IPSets /28 is min in AWS

        compute2                 = "192.168.0.0/16" 
        C2_Downlink_1b           = "192.168.10.0/24"
        C2_Downlink_1c           = "192.168.11.0/24"
        C2_Mgmt_1b               = "192.168.20.0/24"
        C2_Mgmt_1c               = "192.168.21.0/24"
        C2_Uplink_1b             = "192.168.30.0/24"
        C2_Uplink_1c             = "192.168.31.0/24"
        C2_RDSnet_1b             = "192.168.40.0/28" #reduce span for IPSets /28 is min in AWS
        C2_RDSnet_1c             = "192.168.41.0/28" #reduce span for IPSets /28 is min in AWS


   }
}


/*================
Jump Host AMIs
=================*/
variable "JH_AMI" {
    type    = "map"
    default = {
        us-west-1       = "ami-1a033c7a" #Amazon Linux AMI 2017.09.1 (HVM), SSD Volume Type - North California
        us-east-1       = "ami-6057e21a" #Amazon Linux AMI 2017.09.1 (HVM), SSD Volume Type - North Virginia
    }
}

/*================
3Tier Web, App AMIs from Brian
=================*/
variable "Web_AMI" {
    type    = "map"
    default = {
        us-west-1       = "ami-5b6b453b" #Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - North California
        us-east-1       = "ami-254dfe5f" #Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - North Virginia
    }
}
variable "App_AMI" {
    type    = "map"
    default = {
        us-west-1       = "ami-876846e7" #Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - North California
        us-east-1       = "ami-294dfe53" #Ubuntu Server 14.04 LTS (HVM), SSD Volume Type - North Virginia
    }
}