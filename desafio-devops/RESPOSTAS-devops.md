## 1. Gitlab

```
  -> pipeline com build da imagem do app
     -> [plus] linter do Dockerfile (tip: use o https://github.com/hadolint/hadolint)
        -> falhar se houver severidade >= Warning
  -> [plus] scan da imagem usando Trivy (https://github.com/aquasecurity/trivy) standalone (binário)
     -> falhar se houver bug crítico
```

