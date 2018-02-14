
variable "Cmpt1_vpc_id" {}

/*================
vRNI User IAM setup
=================*/
resource "aws_iam_user" "vRNI_user" {
  name = "vRNI_user"
}

resource "aws_iam_policy" "vRNI_AWS_Policy" {
    name = "vRNI_AWS_Policy"
    policy = <<EOF
{
    "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "iam:ListAccountAliases",
                "Resource": "*"
                
            },
            {
                "Effect": "Allow",
                "Action": "ec2:Describe*",
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "elasticloadbalancing:Describe*",
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "cloudwatch:ListMetrics",
                    "cloudwatch:GetMetricStatistics",
                    "cloudwatch:Describe*"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "autoscaling:Describe*",
                "Resource": "*"
            },            
            {
                "Effect": "Allow",
                "Action": [
                "logs:Describe*",
                "logs:Get*",
                "logs:TestMetricFilter",
                "logs:FilterLogEvents"
                ],
                "Resource": "*"
            }
        ]
}
EOF
}


resource "aws_iam_policy_attachment" "attach_user_policy" {
  name       = "attach_user_policy"  
  users      = ["${aws_iam_user.vRNI_user.name}"]
  policy_arn = "${aws_iam_policy.vRNI_AWS_Policy.arn}"
}  

resource "aws_iam_access_key" "vRNIKeys" {
    depends_on = ["aws_iam_policy_attachment.attach_user_policy"]
    user    = "${aws_iam_user.vRNI_user.name}"
}

#####################################


resource "aws_iam_role" "Flow_log_role" {
    description = "Flow_log_role"
    name = "Flow_log_role"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement": [ 
        {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "vpc-flow-logs.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        } 
    ]
}
EOF
}

resource "aws_iam_instance_profile" "Flow_log_role" {
    name = "Flow_log_role"
    role = "${aws_iam_role.Flow_log_role.name}"
}

#######################

resource "aws_iam_role_policy" "Flow_Policy" {
    name = "Flow_policy"
    role = "${aws_iam_role.Flow_log_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [ 
        {
        "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
        ],
        "Effect": "Allow",
        "Resource": "*"
        }
    ]
}   
EOF
}

resource "aws_cloudwatch_log_group" "FlowLogsGroup" {
  name = "FlowLogsGroup"
}

resource "aws_flow_log" "Cmpt_vpc_FlowLog" {
  log_group_name = "${aws_cloudwatch_log_group.FlowLogsGroup.name}"
  iam_role_arn   = "${aws_iam_role.Flow_log_role.arn}"
  vpc_id         = "${var.Cmpt1_vpc_id}"
  traffic_type   = "ALL"
}

/*================
outputs for vRNI
=================*/

output "vRNI_Access"    { value = "${aws_iam_access_key.vRNIKeys.id}"}
output "vRNI_Secret"    { value = "${aws_iam_access_key.vRNIKeys.secret}"}




