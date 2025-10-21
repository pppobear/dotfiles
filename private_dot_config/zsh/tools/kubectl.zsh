#!/usr/bin/env zsh
# kubectl integration and completion

# kubectl completion
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)

  # Useful kubectl aliases
  alias k='kubectl'
  alias kgp='kubectl get pods'
  alias kgs='kubectl get services'
  alias kgd='kubectl get deployments'
  alias kl='kubectl logs'
  alias kd='kubectl describe'
  alias ka='kubectl apply -f'
fi
