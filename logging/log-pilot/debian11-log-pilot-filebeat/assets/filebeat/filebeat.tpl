{{range .configList}}
- type: filestream
  id: path-{{ .HostDir }}/{{ .File }}
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
  buffer_size: 16777216
  message_max_bytes: 10485760
  backoff.init: 4s
  backoff.max: 32s
  clean_inactive: 73h
  ignore_older: 72h
  harvester_limit: 1024

{{end}}
