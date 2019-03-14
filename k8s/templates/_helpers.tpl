{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredential.registry (printf "%s:%s" .Values.imageCredential.username .Values.imageCredential.password | b64enc) | b64enc }}
{{- end }}