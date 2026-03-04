# ClickHouse 数据库连接配置指南

本配置通过环境变量 `CLICKHOUSE_URL` 管理 ClickHouse 连接凭据，避免在代码中硬编码敏感信息。

## 1. 准备连接字符串

### 密码特殊字符转义

如果密码中包含特殊字符（如 `!`、`.` 等），需要进行 URL 编码：

| 字符 | 编码 |
|------|------|
| `!` | `%21` |
| `#` | `%23` |
| `@` | `%40` |
| `:` | `%3A` |
| `/` | `%2F` |

**示例**：
**示例**（使用占位符）：
- 原始密码：`YOUR_PASSWORD`
- 如果密码包含 `!`，编码后：`YOUR_PASSWORD_ENCODED`

### 完整连接字符串格式

```
clickhouse://[user]:[password]@[host]:[port]/[database]?[options]
```

**示例模板**（替换占位符为你的实际值）：
```
clickhouse://default:YOUR_PASSWORD@203.110.233.91:9030/default?secure=true
```

参数说明：
- `user`: ClickHouse 用户名（本例：`default`）
- `password`: 密码（特殊字符需转义）
- `host`: 服务器地址（本例：`203.110.233.91`）
- `port`: HTTP/HTTPS 端口（本例：`9030`，SSL 端口）
- `database`: 默认数据库名（本例：`default`）
- `secure=true`: 使用 SSL/TLS（当端口为 9030 时需要）

## 2. 设置环境变量

### 方式 A：在 Shell 配置文件中（推荐）

编辑你的 shell 配置文件（`.bashrc`、`.zshrc` 等）：

```bash
# 添加以下行
# 添加以下行（替换 YOUR_PASSWORD 为实际密码）
export CLICKHOUSE_URL="clickhouse://default:YOUR_PASSWORD@203.110.233.91:9030/default?secure=true"
```

然后重新加载配置：
```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

### 方式 B：在 `.env` 文件中（开发用）

在项目根目录创建 `.env` 文件：

```bash
# 替换 YOUR_PASSWORD 为实际密码
CLICKHOUSE_URL=clickhouse://default:YOUR_PASSWORD@203.110.233.91:9030/default?secure=true
```

**注意**：`.env` 文件不应提交到 Git，确保已在 `.gitignore` 中。

### 方式 C：临时设置（单次会话）

```bash
# 替换 YOUR_PASSWORD 为实际密码
export CLICKHOUSE_URL="clickhouse://default:YOUR_PASSWORD@203.110.233.91:9030/default?secure=true"
nvim
```

## 3. 验证配置

### 在 Neovim 中检查

打开 Neovim，按下 `<leader>D` 打开数据库面板：

```vim
:DBUI
```

如果环境变量正确设置，应该能看到 "clickhouse" 连接出现在列表中。

### 调试：检查环境变量

在 Neovim 命令行模式下：

```vim
:lua print(os.getenv("CLICKHOUSE_URL"))
```

应该输出完整的连接字符串。

## 4. 故障排查

| 问题 | 原因 | 解决 |
|------|------|------|
| 环境变量未读取 | Shell 配置未重新加载 | 运行 `source ~/.bashrc` 或重启终端 |
| `invalid URL` | 密码中 `!` 未转义 | 确保用 `%21` 替换 `!` |
| 连接失败 | 网络/防火墙问题 | 测试 `nc -zv 203.110.233.91 9030` |
| 连接列表为空 | `CLICKHOUSE_URL` 未设置 | 检查环境变量是否正确导出 |

## 5. Nix Home-Manager 用户

如果使用 Nix Home-Manager，可以在 flake.nix 中配置环境变量：

```nix
{
  home.sessionVariables = {
    CLICKHOUSE_URL = "clickhouse://default:YOUR_PASSWORD@203.110.233.91:9030/default?secure=true";
  };
}
```

然后运行：
```bash
home-manager switch
```

## 6. 安全建议

- ✅ 使用环境变量存储敏感信息
- ✅ 密码中的特殊字符必须 URL 编码
- ✅ 不在配置文件中硬编码凭据
- ✅ 定期更新数据库密码
- ✅ 在团队环境中使用密钥管理工具（如 HashiCorp Vault）

---

**配置完成后**，在 SQL 文件中输入 SQL 查询，按 `Ctrl-N` 会自动显示 ClickHouse 字段补全！
