
variable "region" {
    type = string
    description = "Region Example: eu-central-1"
    default = "eu-central-1"
}

variable "ssh_public_key" {
    type = string
    description = "SSH Public Key for connect to ec2 Instances Example: ssh-rsa AAAAB3NzaC1yc2..."
    default = ""
}
