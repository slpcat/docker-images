resource "ksyun_krds_rr" "my_rds_rr"{
  output_file = "output_file"
  db_instance_identifier= "******"
  db_instance_class= "db.ram.2|db.disk.50"
  db_instance_name = "houbin_terraform_888_rr_1"
  bill_type = "DAY"
  security_group_id = "******"

  parameters {
    name = "auto_increment_increment"
    value = "7"
  }

  parameters {
    name = "binlog_format"
    value = "ROW"
  }
}
