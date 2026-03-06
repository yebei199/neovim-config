-- neovide GUI 前端配置：字体、渲染、光标动画、输入法处理等专属于图形界面的设置
-- 仅在检测到 neovide 环境时执行，其余终端 UI 配置保持原样
if not vim.g.neovide then
    return
end

-- =============================================================================
-- 字体配置 — 使用 Nerd Font 支持图标，多字体后备机制
-- =============================================================================
-- 基础字体设置：可通过 <C-+> 和 <C--> 快捷键动态调整大小（需在 keymaps 中配置）
vim.o.guifont = "FiraCode Nerd Font:h11"
-- 备选方案（取决于系统已安装的字体）：
-- vim.o.guifont = "JetBrains Mono,Noto Color Emoji:h11"
-- vim.o.guifont = "Hack,Noto_Color_Emoji:h12:b"

-- =============================================================================
-- 显示与渲染优化 — 窗口外观、文本渲染质量、透明度
-- =============================================================================
-- 窗口内边距 — 在窗口边界与编辑器内容之间添加 padding，改善视觉平衡
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_left = 10
vim.g.neovide_padding_right = 10

-- 透明度设置 — 允许看到背景，但保持文本完全可读
vim.g.neovide_opacity = 0.95
-- 背景色透明度（0.0 = 完全透明，1.0 = 完全不透明）
-- vim.g.neovide_normal_opacity = 0.95

-- 文本渲染质量 — 调整伽玛值和对比度以适应不同的显示器
vim.g.neovide_text_gamma = 0.0 -- 标准 sRGB gamma (2.2)
vim.g.neovide_text_contrast = 0.5 -- 默认对比度，平衡清晰度与准确色彩

-- 下划线笔触缩放 — 适配高 DPI 或特殊的下划线样式（如 undercurl）
vim.g.neovide_underline_stroke_scale = 1.0

-- =============================================================================
-- 光标动画与视效 — 平滑光标移动、闪烁、粒子效果
-- =============================================================================
-- 光标动画时长 — 影响光标从一处移动到另一处的平滑度（秒）
vim.g.neovide_cursor_animation_length = 0.15
-- 短距离光标动画 — 打字时光标在相邻字符间移动的速度（秒）
vim.g.neovide_cursor_short_animation_length = 0.04
-- 光标尾部轨迹大小 — 0.0 = 无尾部，1.0 = 最大尾部长度
vim.g.neovide_cursor_trail_size = 0.8

-- 光标无焦点时的轮廓宽度 — 窗口失焦时显示光标轮廓，便于定位
vim.g.neovide_cursor_unfocused_outline_width = 0.125

-- 光标平滑闪烁 — 启用后光标闪烁时进行平滑过渡而非突然切换（需 guicursor 启用闪烁）
vim.g.neovide_cursor_smooth_blink = true

-- 光标抗锯齿 — 抗锯齿光标四边形（若有视觉问题可禁用）
vim.g.neovide_cursor_antialiasing = true

-- 在插入模式下动画光标 — 禁用则光标在插入模式下立即跳转而非平滑移动
vim.g.neovide_cursor_animate_in_insert_mode = true

-- 光标动画切换到命令行 — 禁用则命令行与编辑器间光标立即跳转
vim.g.neovide_cursor_animate_command_line = true

-- 光标粒子效果模式 — 支持的值："railgun", "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe", ""（无）
vim.g.neovide_cursor_vfx_mode = "railgun"
-- 粒子视效透明度
vim.g.neovide_cursor_vfx_opacity = 200.0
-- 粒子生命周期 — railgun 风格使用这个时间
vim.g.neovide_cursor_vfx_particle_lifetime = 0.5
-- 粒子密度 — 单位为每行路径的粒子数
vim.g.neovide_cursor_vfx_particle_density = 0.7
-- 粒子速度 — 像素/秒
vim.g.neovide_cursor_vfx_particle_speed = 10.0
-- railgun 风格专属：粒子相位 — 越高越"神经质"，越低越像正弦波
vim.g.neovide_cursor_vfx_particle_phase = 1.5
-- railgun 风格专属：粒子卷曲度 — 影响速度旋转
vim.g.neovide_cursor_vfx_particle_curl = 1.0

-- =============================================================================
-- 浮窗与视觉增强 — 浮窗模糊、阴影、圆角
-- =============================================================================
-- 浮窗模糊量 — 为浮窗添加高斯模糊背景（视觉改善）
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- 浮窗阴影效果 — 为浮窗添加 3D 阴影
vim.g.neovide_floating_shadow = true
-- 浮窗虚拟高度 — 从地面平面的虚拟高度（影响阴影大小）
vim.g.neovide_floating_z_height = 10
-- 光源角度 — 投射阴影的光源角度（度）
vim.g.neovide_light_angle_degrees = 45
-- 光源半径 — 投射光源的半径（像素）
vim.g.neovide_light_radius = 5

-- 浮窗圆角半径 — 0.0 = 直角，1.0 = 完全圆形（行高的百分比）
vim.g.neovide_floating_corner_radius = 0.0

-- =============================================================================
-- 功能与交互 — 刷新率、动画、输入、窗口行为
-- =============================================================================
-- 隐藏鼠标当输入时 — 在键盘输入时自动隐藏鼠标（仅在窗口内有效）
vim.g.neovide_hide_mouse_when_typing = true

-- 菜单项拖拽选择 — 在消息窗口（如 :messages）中允许鼠标拖选
vim.g.neovide_message_area_drag_selection = false

-- 滚动动画时长 — 影响 Page Up/Down 等大幅滚动的平滑度（秒）
vim.g.neovide_scroll_animation_length = 0.3
-- 远距离滚动行数 — 屏幕以上的滚动仅动画这么多行（性能优化，1 = 仅底部行动画）
vim.g.neovide_scroll_animation_far_lines = 1

-- 窗口位置动画时长 — split 等操作的窗口移动动画（秒，0 = 禁用）
vim.g.neovide_position_animation_length = 0.15

-- 刷新率 — 限制应用刷新率（Hz，受硬件限制）
vim.g.neovide_refresh_rate = 60
-- 空闲刷新率 — 应用失焦时的刷新率（节省电池，Hz）
vim.g.neovide_refresh_rate_idle = 5

-- 记住上次窗口大小 — 下次启动时恢复之前的窗口尺寸
vim.g.neovide_remember_window_size = true

-- 退出时确认 — 有未保存更改时要求确认
vim.g.neovide_confirm_quit = true

-- =============================================================================
-- 输入法与键盘 — IME 处理、macOS 特定选项
-- =============================================================================
-- IME 输入法支持 — 启用后支持中文、日文等非拉丁输入，通过 autocmd 按场景切换
vim.g.neovide_input_ime = false

-- 虚拟触摸死区 — 触摸屏误触阈值（像素，< 0 时禁用）
vim.g.neovide_touch_deadzone = 6.0
-- 触摸拖拽超时 — 手指需要按住多久才视为拖拽（秒）
vim.g.neovide_touch_drag_timeout = 0.17

-- macOS 特定：Option 键作为 Meta — 'only_left', 'only_right', 'both', 'none'
-- vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

-- =============================================================================
-- IME 自动切换 — 根据当前模式启用/禁用 IME（针对中日韩用户）
-- =============================================================================
-- 在插入模式、命令行搜索时自动启用 IME，其他模式禁用，便于 Vim 快捷键导航
vim.api.nvim_create_autocmd({
    "InsertEnter",
    "InsertLeave",
    "TermEnter",
    "TermLeave",
    "CmdlineEnter",
    "CmdlineLeave",
}, {
    group = vim.api.nvim_create_augroup("neovide_ime_input", { clear = true }),
    pattern = "*",
    callback = function(args)
        -- 如果事件名以 "Enter" 结尾，启用 IME；否则禁用
        vim.g.neovide_input_ime = not not args.event:match("Enter$")
    end,
})
