# current-key-format 分支说明

这个分支是我自己维护的 tmux 3.2a patched 版本，不是给 tmux 官方 upstream 直接提 PR 的干净主线分支。

## 基线

- 基于官方 tmux `3.2a` 发布点/tag。
- 放弃之前基于另一条 upstream/master 历史做出来的 `current-key-format` 旧分支基线。
- 目标是维护一个稳定可用、便于自己安装和复现的 WSL / Windows Terminal 体验分支。

## 这个分支维护了什么

源码层主要加入这些能力：

1. `#{current_key}` / `#{current_key_with_flags}` format
   - 让 tmux binding 能拿到当前触发按键。
   - 用于 copy-mode 中中文/IME 输入首字直通，避免第一个字被吞。

2. normal-mode WT-like viewport
   - 在普通输入模式下滚轮上滚进入类似 Windows Terminal 的历史 viewport。
   - 不强制进入 copy-mode。
   - 键盘输入会立刻回到底部 live pane，并把按键原样送给 pane。

3. 流式输出时的 viewport 稳定性
   - viewport 脱离底部时，后台 live 输出只更新 backing grid，不直接写真实 tty。
   - 避免 Hermes / prompt_toolkit / Rich 流式输出时，历史区固定某一行闪烁。
   - 对 history 增长的 anchor 跟随做 redraw 抑制，避免无意义重画。

4. live bottom 滚动稳定性
   - active live pane 输出滚屏时避免物理 scrollup 把输入框顶起一帧。
   - 改为确定性 redraw，减少底部输入区域抽动。

5. copy-mode 到 normal viewport 的衔接
   - 鼠标拖选复制后退出 copy-mode，但保留当前历史位置为普通 viewport。
   - 不跳回底部，也不把界面卡在 copy-mode。

6. viewport / copy-mode 光标处理
   - 历史 viewport 和 copy-mode 中隐藏真实块状 cursor。
   - 回到底部输入时恢复 cursor。

## 配置与产物

本分支额外保留了当前 WSL 使用中的配置备份：

- `user-config/wsl-tmux/`
  - `tmux.conf`：当前 `~/.tmux.conf` 备份。
  - `bin/`：配套 helper scripts，例如中文帮助、Windows 剪贴板桥、滚轮行数读取、cursor hide/show、copy-mode 输入直通。

本分支也保留了当前 WSL 下已编译可运行的 binary：

- `release/wsl/tmux`
- `release/wsl/tmux.sha256`
- `release/wsl/README.md`

注意：`release/wsl/tmux` 是本机 WSL 环境下的编译产物，用于快速恢复当前环境；跨系统使用时建议按源码重新编译。

## 分支卫生规则

- 不提交 configure/make 产生的中间产物：`.deps/`、`*.o`、`Makefile`、`config.status` 等。
- 不使用 `git add .` 乱加文件。
- 源码改动集中在少量 `.c/.h` 文件和 `configure.ac` 版本标记。
- 配置备份和 release binary 放在明确的单独目录中。
