# Lua TreeSitter 查询定义

## 概述

本目录包含Lua语言的TreeSitter查询文件，用于定义语法高亮和代码分析规则。查询文件采用Scheme语法，通过模式匹配提供精确的代码结构识别和样式定义。

## TreeSitter查询简介

TreeSitter查询使用S表达式语法，在语法树中匹配特定代码模式。支持定义高亮规则、折叠边界、文本对象等功能，相较正则表达式更加准确和强大。

## 目录结构

```
queries/lua/
├── highlights.scm    # 语法高亮定义
└── README.md         # 说明文档
```

## 当前配置

### highlights.scm

该文件扩展基础Lua高亮规则：

```scheme
;; extends
((identifier) @namespace.builtin
  (#eq? @namespace.builtin "vim"))
```

此规则将`vim`标识符标记为内置命名空间，确保在Neovim Lua配置中正确高亮显示。

## 查询类型

- **高亮查询**：定义代码元素颜色和样式
- **折叠查询**：指定可折叠代码块边界
- **局部查询**：分析变量作用域和生命周期
- **缩进查询**：定义自动缩进规则

## Neovim集成

查询文件自动集成到Neovim TreeSitter系统，提供精确语法分析、性能优化和插件支持。

## 扩展指南

添加新查询时，创建.scm文件，使用S表达式编写模式，测试匹配效果。注意保持精确性，遵循Lua语法规范。