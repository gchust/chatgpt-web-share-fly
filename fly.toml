app = "cwsgpt"
primary_region = "sin"

[mounts]
  source="cwsgpt"
  destination="/cws_db"
[env]
  SWAP = "true"

[http_service]
  internal_port = 80
  force_https = true
  auto_stop_machines = false
  auto_start_machines = true
  min_machines_running = 1