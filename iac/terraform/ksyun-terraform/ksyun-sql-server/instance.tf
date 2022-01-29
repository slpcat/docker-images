provider "ksyun"{
  region = "cn-shanghai-3"
  access_key = ""
  secret_key = ""
}

variable "available_zone" {
  default = "cn-shanghai-3a"
}
resource "ksyun_vpc" "default" {
  vpc_name   = "ksyun-vpc-tf"
  cidr_block = "10.7.0.0/21"
}
resource "ksyun_subnet" "foo" {
  subnet_name = "ksyun-subnet-tf"
  cidr_block = "10.7.0.0/21"
  subnet_type = "Reserve"
  dhcp_ip_from = "10.7.0.2"
  dhcp_ip_to = "10.7.0.253"
  vpc_id  = "${ksyun_vpc.default.id}"
  gateway_ip = "10.7.0.1"
  dns1 = "198.18.254.41"
  dns2 = "198.18.254.40"
  availability_zone = "${var.available_zone}"
}

resource "ksyun_sqlserver" "sqlserver-1"{
  output_file = "output_file"
  dbinstanceclass= "db.ram.2|db.disk.20"
  dbinstancename = "ksyun_sqlserver_1"
  dbinstancetype = "HRDS_SS"
  engine = "SQLServer"
  engineversion = "2008r2"
  masterusername = "admin"
  masteruserpassword = "123qweASD"
  vpc_id = "${ksyun_vpc.default.id}"
  subnet_id = "${ksyun_subnet.foo.id}"
  billtype = "DAY"
}

