{{range .configList}}
- type: log
  enabled: true
  paths:
      - {{ .HostDir }}/{{ .File }}
  scan_frequency: 10s
  fields_under_root: true
  {{if .Stdout}}
  #docker-json: true
  {{end}}
  {{if eq .Format "json"}}
  json.keys_under_root: true
  json.overwrite_keys: true
  {{end}}
  fields:
      {{range $key, $value := .Tags}}
      {{ $key }}: {{ $value }}
      {{end}}
      {{range $key, $value := $.container}}
      {{ $key }}: {{ $value }}
      {{end}}
  tail_files: false
  close_inactive: 4h
  close_eof: false
  close_removed: true
  clean_removed: true
  close_renamed: true
  harvester_buffer_size: 524288
  backoff: 4s
  max_backoff: 32s
  message_max_bytes: 10485760
  clean_inactive: 73h
  ignore_older: 72h
  harvester_limit: 1024

{{end}}
