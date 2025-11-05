-- WezTerm 配置文件 (Linux 适用，无 Bash)
local wezterm = require 'wezterm'
local config = {}

-- 使用更好的配置方式（如果 WezTerm 版本支持）
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 窗口设置
config.window_background_opacity = 0.95 -- 透明度
config.window_padding = { -- 内边距
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}
config.window_decorations = "TITLE | RESIZE" -- 显示标题栏

-- 字体设置
config.font = wezterm.font('SauceCodePro Nerd Font') -- 使用已安装的 Nerd Font
config.font_size = 10.0

-- 颜色主题（Campbell）
config.colors = {
  foreground = '#CCCCCC', -- 浅灰色前景
  background = '#0C0C0C', -- 黑色背景
  -- 普通颜色
  ansi = {
    '#0C0C0C', -- black
    '#C50F1F', -- red
    '#13A10E', -- green
    '#C19C00', -- yellow
    '#0037DA', -- blue
    '#881798', -- magenta
    '#3A96DD', -- cyan
    '#CCCCCC', -- white
  },
  -- 明亮颜色
  brights = {
    '#767676', -- bright black（灰色）
    '#E74856', -- bright red
    '#16C60C', -- bright green
    '#F9F1A5', -- bright yellow
    '#3B78FF', -- bright blue
    '#B4009E', -- bright magenta
    '#61D6D6', -- bright cyan
    '#F2F2F2', -- bright white
  },
}

-- 启动器配置（已移除 Bash 选项）
config.launch_menu = {
  {
    label = 'Zsh シェル', -- Zsh Shell
    args = { '/bin/zsh' },
  },
  {
    label = 'リモート SSH 接続', -- Remote SSH Connection
    args = { 'ssh', 'user@hostname' },
  },
}

-- 光标设置
config.default_cursor_style = 'SteadyBlock'

-- 选择时自动复制到剪贴板
config.selection_word_boundary = ' \t\n{}"'`'

-- 鼠标绑定
config.mouse_bindings = {
  -- 右键粘贴
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- 按键绑定
config.keys = {
  -- 新增：将 Ctrl+Shift+Y 设置为全屏切换
  {
    key = 'Y',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ToggleFullScreen,
  },
  -- 新增：禁用默认的 Alt+Enter 全屏切换功能
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Ctrl+Shift+V 粘贴
  {
    key = 'V',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  -- Shift+Enter 发送换行 (通常用于嵌入式开发中的特殊发送)
  {
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action.SendString '\x1b\r',
  },
  -- Ctrl+Shift+C 复制
  {
    key = 'C',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  -- Ctrl+Shift+N 新实例
  {
    key = 'N',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnWindow,
  },
  -- Ctrl+Shift+T 也打开新窗口（而不是新标签）
  {
    key = 'T',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnWindow,
  },
  -- Ctrl+Shift+S 打开启动器菜单
  {
    key = 'S',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|LAUNCH_MENU_ITEMS' },
  },
}

-- 启用扩展键支持
config.enable_csi_u_key_encoding = false

-- 其他设置
config.scrollback_lines = 10000
config.enable_tab_bar = true -- 启用标签栏
config.hide_tab_bar_if_only_one_tab = false -- 即使只有一个标签也显示标签栏

-- 输入法 (IME) 支持 - 启用中文/日语输入
config.use_ime = true -- 启用输入法支持
config.xim_im_name = "fcitx5" -- 指定使用 fcitx5

return config
