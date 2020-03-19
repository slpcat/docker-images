job "mysql-backup" {

  datacenters = ["dc1"]

  type = "batch"

  constraint {
    attribute = "${attr.unique.hostname}"
    regexp = ".*mysql-backup"
  }

  periodic {
    // Launch every hour
    cron = "0 * * * * *"

    // Do not allow overlapping runs.
    prohibit_overlap = true
  }

  task "run-mysql-backup" {
    driver = "raw_exec"

    config {
      # When running a binary that exists on the host, the path must be absolute
      command = "/usr/local/bin/mysql-backup.sh"
    }

    resources {
      # defaults
    }
  }
}
