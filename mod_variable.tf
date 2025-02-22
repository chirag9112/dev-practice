variable "region" {
   default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "project" {
  default = "module_era"
}
variable "subnet_cidr" {
  default = "10.0.0.0/20"
}
variable "az1"{
   default = "us-east-1a"
}
variable "ami_id" {
  default = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
   default = "chirag_rsa"
}
variable "sgid" {
  default = "sg-0554a9833952b8735"
}