# ollama

## install/upgrade
helm upgrade --create-namespace --install ollama ollama-helm/ollama --namespace ollama --values ollama.values.yaml

## uninstall
helm uninstall -n ollama ollama
