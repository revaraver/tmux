# WSL tmux 配置备份说明

这个目录保存当前 WSL 实际使用中的 tmux 配置和配套脚本。

## 文件

- `tmux.conf`
  - 当前 `~/.tmux.conf` 的备份。
  - 包含中文帮助、鼠标模式、Windows 剪贴板桥、copy-mode 输入直通、cursor hide/show、WT-like 滚轮相关 binding。

- `bin/tmux-cn-help`
  - `Ctrl+b ?` 中文帮助弹窗内容。
  - `Ctrl+b F1` 仍保留 tmux 原生英文帮助。

- `bin/tmux-paste-windows-clipboard`
  - 右键从 Windows 侧 daemon 读取剪贴板，再由 tmux paste 到当前 pane。
  - 避免依赖前台窗口 `SendInput(Ctrl+V)`。

- `bin/tmux-refresh-wheel-lines`
  - 从 Windows 注册表读取鼠标滚轮行数，写入 tmux 环境变量 `TMUX_WHEEL_LINES`。

- `bin/tmux-cursor-hide-delayed`
- `bin/tmux-cursor-show`
- `bin/tmux-cursor-visibility`
  - 控制 copy-mode / normal viewport 中的 cursor 显示状态。

- `bin/tmux-wheel-up-guarded`
- `bin/tmux-wheel-down-guarded`
  - copy-mode 兼容路径的滚轮脚本。
  - patched tmux 的 normal-mode viewport 不主要依赖它们，但保留用于 copy-mode/selection 场景。

- `bin/tmux-copy-mode-send-key`
  - copy-mode 中输入任意普通键时，先退出历史视图，再把按键送回 pane。

## 恢复方式

在 WSL 中进入仓库根目录后执行：

```bash
install -Dm644 user-config/wsl-tmux/tmux.conf ~/.tmux.conf
mkdir -p ~/.local/bin
install -m755 user-config/wsl-tmux/bin/* ~/.local/bin/
tmux source-file ~/.tmux.conf
```

如果当前 tmux server 不是 patched binary 启动的，`#{current_key}`、`#{pane_wt_offset}` 和 normal-mode viewport 相关能力不会生效。需要先用 `release/wsl/tmux` 或自行编译的 patched tmux 重启 tmux server。

## 依赖/环境

- WSL + Windows Terminal。
- Windows 剪贴板写入依赖 `clip.exe`。
- 右键粘贴路径依赖本机已配置的 Windows clipboard daemon；没有 daemon 时可关掉相关右键 binding，仍可用 WT 原生 Ctrl+V 或 tmux buffer。
