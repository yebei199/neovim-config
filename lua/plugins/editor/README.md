# editor — 编辑功能增强插件

扩展 Neovim 内建编辑能力的插件集合，每个插件针对特定的编辑痛点，相互之间功能互不重叠。

## 文件

- `flash.lua` — 可见区域内的快速光标跳转，减少 `hjkl` 连续移动，支持按字符标签直达目标位置
- `surround.lua` — 配对符号（括号、引号、标签等）的增删改操作，兼容 vim motions 的操作范式
- `mini-ai.lua` — 增强版文本对象，提供参数、函数体、条件分支等语义级的选择和操作单元
- `pair.lua` — 输入时自动补全配对符号，支持多语言符号规则和嵌套场景的智能处理
- `gitsign.lua` — 在行号列实时显示 Git 变更标记（新增/修改/删除），支持 hunk 预览和选择性暂存
- `grug-far.lua` — 项目范围的多模式搜索替换，支持预览和批量应用，替代 `:s` 的复杂用法
- `substitute.lua` — 增强替换操作，提供更直观的 substitute motion 语义
- `coerce.lua` — 变量名格式快速转换（camelCase、snake_case、PascalCase 等）
- `yanky.lua` — 寄存器历史管理，支持循环粘贴历史内容，解决默认粘贴只能访问最近一次复制的限制
