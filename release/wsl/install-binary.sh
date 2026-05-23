#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

mkdir -p "$HOME/.local/tmux-current-key/bin" "$HOME/.local/bin"
install -m755 "$repo_root/release/wsl/tmux" "$HOME/.local/tmux-current-key/bin/tmux"
ln -sf "$HOME/.local/tmux-current-key/bin/tmux" "$HOME/.local/bin/tmux"

"$HOME/.local/bin/tmux" -V
printf '\n已安装到：%s\n' "$HOME/.local/tmux-current-key/bin/tmux"
printf '软链：%s\n' "$HOME/.local/bin/tmux"
printf '\n注意：如果旧 tmux server 正在运行，需要重启 server 才会吃到新 binary。\n'
