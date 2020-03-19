{{/* vim: set filetype=mustache: */}}

{{- define "orgName" -}}
org
{{- end -}}

{{- define "genesisBlockFile" -}}
genesis.block
{{- end -}}

{{- define "ordererMsp" -}}
OrdererMSP
{{- end -}}

{{- define "orgMspList" -}}
  {{- range $dummy, $orgIndex := untilStep 1 (int (add (int $.Values.orgNum) 1)) 1 }}Org{{ $orgIndex }}MSP {{ end -}}
{{- end -}}
