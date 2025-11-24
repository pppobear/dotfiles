#!/usr/bin/env zsh
# kubectl integration and completion - Cached for faster startup

# kubectl completion
if command -v kubectl >/dev/null 2>&1; then
  # Ensure compinit is loaded before kubectl completion
  autoload -Uz compinit
  compinit

  # Cache completion to avoid regenerating on every startup
  _kubectl_completion="${ZDOTDIR:-$HOME/.config/zsh}/.kubectl_completion"
  if [[ ! -f "$_kubectl_completion" ]] || [[ $(find "$_kubectl_completion" -mtime +7 2>/dev/null) ]]; then
    kubectl completion zsh > "$_kubectl_completion" 2>/dev/null
  fi
  [[ -f "$_kubectl_completion" ]] && source "$_kubectl_completion"
  unset _kubectl_completion

  # Useful kubectl aliases
  alias k='kubectl'
  alias kgp='kubectl get pods'
  alias kgs='kubectl get services'
  alias kgd='kubectl get deployments'
  alias kl='kubectl logs'
  alias kd='kubectl describe'
  alias ka='kubectl apply -f'
fi
