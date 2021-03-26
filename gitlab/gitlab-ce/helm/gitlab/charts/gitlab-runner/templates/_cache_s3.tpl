{{- define "gitlab-runner.cache_s3" }}
- name: CACHE_TYPE
  value: {{ default "" .Values.runners.cache.cacheType | quote }}
- name: S3_SERVER_ADDRESS
  value: {{ template "gitlab-runner.cache.s3ServerAddress" . }}
- name: S3_BUCKET_NAME
  value: {{ default "" .Values.runners.cache.s3BucketName | quote }}
- name: S3_BUCKET_LOCATION
  value: {{ default "" .Values.runners.cache.s3BucketLocation | quote }}
{{-   if .Values.runners.cache.s3CacheInsecure }}
- name: S3_CACHE_INSECURE
  value: "true"
{{-   end }}
- name: S3_CACHE_PATH
  value: {{ default "" .Values.runners.cache.s3CachePath | quote }}
{{-   if .Values.runners.cache.cacheShared }}
- name: CACHE_SHARED
  value: "true"
{{-   end }}
{{- end -}}
