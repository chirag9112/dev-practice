output "aws_instance" {
    value=module.my_instance.aws_instance.module_instance.public_ip
}

output "aws_vpc" {
    value = module.my_vpc.aws_vpc.my_vpc.id
}

output "subent_id" {
    value = module.my_vpc.aws_subnet.my_subnet.id
}
