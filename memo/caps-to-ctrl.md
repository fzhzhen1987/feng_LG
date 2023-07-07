# 键盘改键:用 keyd 统一替代 .Xmodmap + xbindkeys

## 为什么换 keyd
xmodmap(.Xmodmap)、xbindkeys 只在 X11(Xorg)有效,Wayland 完全不生效,
且注销 / 键盘热插拔后会被重置 —— 这是以前"老失效"的根因。
keyd 工作在内核 input 层,X11 / Wayland / 纯控制台都生效,永不失效。
一份 keyd 配置即可替代原来 .Xmodmap + .xbindkeysrc + keysetting.sh + keyboard.desktop 整条链。

## 原 .Xmodmap / xbindkeys 做的事(从历史抠出的确切映射,供对照)
- Caps 与 左Ctrl 互换            (keycode 66↔37)
- 右Ctrl → 截屏键 PrtSc           (keycode 105 → Print)
- 右Alt → 鼠标中键               (keycode 108 → XF86WebCam,再由 xbindkeys 跑 `xdotool click 2`)
- 物理 PrtSc 键 → 启动终端        (keycode 107 → XF86Game,由桌面快捷键启动终端)

## 1. 安装 keyd(在真机上 sudo 执行)

# Ubuntu/Debian 若有包
sudo apt install keyd

# 没有包就源码装
# git clone https://github.com/rvaiya/keyd && cd keyd && make && sudo make install

## 2. 写配置:/etc/keyd/default.conf

[ids]
*

[main]
# Caps 与 左Ctrl 互换(只想 Caps 当 Ctrl、不动左Ctrl,就删掉第二行)
capslock = leftcontrol
leftcontrol = capslock

# 右Ctrl → 截屏键(发 PrtSc;真正"截屏"动作由桌面对 PrtSc 的快捷键完成)
rightcontrol = sysrq

# 右Alt → 鼠标中键
rightalt = middlemouse

## 3. 启用

# 开机自启并立即启动
sudo systemctl enable --now keyd

# 以后改完配置重载
sudo keyd reload

## 4. "PrtSc 键 → 启动终端" 这项怎么办
这是「动作」不是「改键」,keyd 只负责把键映射成键。两种做法:

# 做法 A(推荐):在桌面环境「设置 → 键盘 → 快捷键」里,把 PrtSc(或任意键)
#   绑定为启动 wezterm —— 和原来桌面绑 XF86Game 启动终端是同一回事。

# 做法 B:让 keyd 直接跑命令(keyd 以 root 运行,启动图形程序要自己处理
#   DISPLAY/用户环境,容易出问题,不推荐)。在 [main] 里:
# sysrq = command(setsid -f wezterm)

## 5. 截屏动作
桌面默认一般已把 PrtSc 绑成截图;上面"右Ctrl → sysrq"后,按右Ctrl 即触发截图。
若没绑,在桌面快捷键里把 PrtSc 绑成你的截图工具即可。

## 调试 / 验证

# 列出 keyd 认的所有键名
keyd list-keys

# 实时查看按键被识别成什么
sudo keyd monitor

## 查键码 / 生成 .Xmodmap 参考(X11 真机上跑;Wayland / WSL 无效)
改键前想知道某个键的 keycode / keysym,或要一份键位表作参考时用:

# 运行后按下那个键,终端打印它的 keycode 和 keysym(改键最常用)
xev -event keyboard

# 导出当前完整的 keycode → keysym 表(这就是 .Xmodmap 的主体,随时可再生,不必留文件)
xmodmap -pke

# 想存成文件留作参考
xmodmap -pke > ~/.Xmodmap.ref

# 导出修饰键映射(Shift / Control / Lock 等分别绑在哪些键)
xmodmap -pm

# keyd 体系下查键名(写 keyd 配置时对应这些名字)
keyd list-keys

## 切换成功后这些就是垃圾、可一并删除
# .Xmodmap  .xbindkeysrc  keysetting.sh  .config/autostart/keyboard.desktop
