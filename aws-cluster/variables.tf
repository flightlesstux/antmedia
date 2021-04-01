
variable "region" {
    type = string
    description = "Region Example: eu-central-1"
    default = "eu-central-1"
}

variable "zones" {
    description = "Zones Example: [\"eu-central-1a\", \"eu-central-1b\"]"
    type = list
    default = ["eu-central-1a", "eu-central-1b"]
}

variable "ssh_public_key" {
    type = string
    description = "SSH Public Key for connect to ec2 Instances Example: ssh-rsa AAAAB3NzaC1yc2..."
    default = ""
}

variable "ssl" {
    description = "ACM ARN for Secure Loadbalancer"
    type = string
    default = ""
}

variable "origin_ec2_type" {
    description = "Origin Server Instance Type Example: t2.large"
    type = string
    default = ""
}

variable "edge_ec2_type" {
    description = "Edge Server Instance Type Example: t2.large"
    type = string
    default = ""
}

variable "email" {
    description = "Email address for AutoScale Activity Notifications Example: autoscale@domain.com"
    type = string
    default = ""
}