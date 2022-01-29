resource "ksyun_instance" "default" {
  image_id      = "48de6f74-e287-45df-b55e-94266d77483f"
  instance_type = "N3.2B"
  system_disk {
    disk_type = "SSD3.0"
    disk_size = 30
  }
  data_disk_gb = 0

  #only support part type
 
  subnet_id            = "e9b83973-b6aa-48b3-b400-d45cfdb832a4"
  instance_password    = "Qwer1234"
  keep_image_login     = false
  charge_type          = "Daily"
  purchase_time         = ""
  security_group_id    = ["c628fd6a-c480-41aa-8fad-02879cfe60fb"]
  private_ip_address   = ""
  instance_name        = "xuan-tf-update"
  instance_name_suffix = ""
  sriov_net_support    = false
  project_id           = 0
  data_guard_id        = ""
}

