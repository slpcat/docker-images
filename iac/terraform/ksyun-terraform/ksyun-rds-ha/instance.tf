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
  subnet_name      = "ksyun-subnet-tf"
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

resource "ksyun_krds_security_group" "krds_sec_group_14" {
  output_file = "output_file"
  security_group_name = "terraform_security_group_14"
  security_group_description = "terraform-security-group-14"
  security_group_rule{
    security_group_rule_protocol = "182.133.0.0/16"
    security_group_rule_name = "asdf"
  }
  security_group_rule{
    security_group_rule_protocol = "182.134.0.0/16"
    security_group_rule_name = "asdf2"
  }
}

resource "ksyun_krds" "my_rds_xx"{
  output_file = "output_file"
  db_instance_class= "db.ram.2|db.disk.21"
  db_instance_name = "houbin_terraform_1-n"
  db_instance_type = "HRDS"
  engine = "mysql"
  engine_version = "5.7"
  master_user_name = "admin"
  master_user_password = "123qweASD123"
  vpc_id = "${ksyun_vpc.default.id}"
  subnet_id = "${ksyun_subnet.foo.id}"
  bill_type = "DAY"
  security_group_id = "${ksyun_krds_security_group.krds_sec_group_14.id}"
  preferred_backup_time = "01:00-02:00"
  availability_zone_1 = "cn-shanghai-3a"
  availability_zone_2 = "cn-shanghai-3b"
  instance_has_eip = true
}
