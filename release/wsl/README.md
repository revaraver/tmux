# WSL release binary

这个目录保存当前 WSL 环境下已经编译好的 tmux binary，用于快速恢复当前正在使用的 patched tmux。

## 文件

- `tmux`
  - WSL 下已编译产物。
  - 当前版本输出：

    ```text
    tmux 3.2a-current-key-viewport-nocursor-streamfix-scrollshield-copyvpfix-cursorfix-anchorfix
    ```

- `tmux.sha256`
  - `tmux` binary 的 SHA256 校验值。

## 安装

在 WSL 中进入仓库根目录后执行：

```bash
mkdir -p ~/.local/tmux-current-key/bin ~/.local/bin
install -m755 release/wsl/tmux ~/.local/tmux-current-key/bin/tmux
ln -sf ~/.local/tmux-current-key/bin/tmux ~/.local/bin/tmux
~/.local/bin/tmux -V
```

如果已经有 tmux server 在跑，安装新 binary 不会自动替换已运行 server。需要退出/杀掉旧 tmux server 后重新进入：

```bash
tmux kill-server
~/.local/bin/tmux new -A -s main
```

注意：`tmux kill-server` 会结束当前 tmux server 里的 session，请确认没有重要进程只挂在 tmux 里无人接管。

## 校验

```bash
sha256sum -c release/wsl/tmux.sha256
```

## 说明

这个 binary 来自本机 WSL 中已经验证过的 tmux 3.2a patched 构建树：

```text
/home/revar/src/tmux-current-key/tmux-3.2a-release
```

它适合当前 WSL 环境快速恢复；换机器、换发行版或换系统库后，建议从本分支源码重新编译。
