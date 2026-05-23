#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
config_dir="$repo_root/user-config/wsl-tmux"

install -Dm644 "$config_dir/tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.local/bin"
install -m755 "$config_dir/bin"/* "$HOME/.local/bin/"

printf '已恢复 tmux 配置：%s\n' "$HOME/.tmux.conf"
printf '已恢复 helper scripts 到：%s\n' "$HOME/.local/bin"

if command -v tmux >/dev/null 2>&1 && tmux display-message -p '#{version}' >/dev/null 2>&1; then
  tmux source-file "$HOME/.tmux.conf"
  printf '已 source 当前 tmux server 的配置。\n'
else
  printf '当前没有可用 tmux server；下次启动 tmux 时会读取 ~/.tmux.conf。\n'
fi
