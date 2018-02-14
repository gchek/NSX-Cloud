/*================
Outputs from VPCs Module needed for ansible
=================*/
output "Cmpt1_vpc_id"               {value = "${module.VPCs.Cmpt1_vpc_id}"}
output "Cmpt2_vpc_id"               {value = "${module.VPCs.Cmpt2_vpc_id}"}

/*================
Outputs from EC2 Module needed for ansible
=================*/
output "Cmpt1_Jumphost_ip"          {value = "${module.EC2.Cmpt1_Jumphost_ip}"}
output "Cmpt2_Jumphost_ip"          {value = "${module.EC2.Cmpt2_Jumphost_ip}"}


/*================
Outputs from Subnets Module needed for ansible
=================*/
output "NSX_C1_Mgmt_subnet"         {value = "${module.Subnets.C1_Mgmt}" }
output "NSX_C1_Up_link_subnet"      {value = "${module.Subnets.C1_Uplink}" }
output "NSX_C1_DownLink_subnet"     {value = "${module.Subnets.C1_Downlink}" }

/*================
Outputs from 3Tier Module needed for ansible
=================*/
output "rds_instance_address"       {value = "${module.3Tier.rds_instance_address}" }
output "DBuser"                     {value = "${module.3Tier.DBuser}" }
output "DBpass"                     {sensitive = true value = "${module.3Tier.DBpass}" }


output "appVM_IP"                   {value = "${module.3Tier.appVM_IP}"}
output "webVM_IPs"                  {value = "${module.3Tier.webVM_IPs}"}
output "web_count"                  {value = "${module.3Tier.web_count}"}

/*================
outputs for vRNI
=================*/
output "vRNI_Access"                { value = "${module.vRNI.vRNI_Access}"}
output "vRNI_Secret"                { value = "${module.vRNI.vRNI_Secret}"}

/*================
outputs
=================*/

output "region"                     { value = "${var.region}"}
output "Key_pair"                   { value = "${module.EC2.Key_pair}"}

        
