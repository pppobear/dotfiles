# AGENTS.md

## Output

- 总是使用简体中文回答我
- 不要附带 Emoji

## Obsidian 外部记忆

当用户明确要求使用 Obsidian 长期记忆，或任务本身属于个人知识库、Obsidian、AI memory 工作流时，使用以下协议。obsidian-cli 需要沙箱提权。

### Vault

- 路径：`~/Documents/personal-vault`

### 启动时默认读取

- `21-Memory/persona.md`
- `21-Memory/projects.md`
- `21-Memory/retrieval.md`

### 条件读取

- 如果任务明显属于某个项目，先从 `21-Memory/projects.md` 找入口，再读取 `30-Projects/` 中对应项目笔记
- 如果任务与历史实现、架构取舍、旧约束相关，再读取 `21-Memory/decisions/` 中相关笔记
- 如果任务是续做，再读取 `21-Memory/sessions/` 中最近且相关的笔记

### 工具约束

- 对 Obsidian vault 中 `.md` 文件的所有读写操作，必须通过 `obsidian:obsidian-markdown` skill 执行
- 对 vault 的搜索、任务管理、属性操作等，必须通过 `obsidian:obsidian-cli` skill 执行
- 禁止使用 Read/Write/Edit 等通用文件工具直接操作 vault 文件，以确保 wikilinks、frontmatter、callouts 等 Obsidian 格式规范

### 记忆写回规则

- 当前进度、阻塞、下一步写入 `21-Memory/sessions/`
- 稳定偏好写入 `21-Memory/persona.md`
- 项目映射和入口写入 `21-Memory/projects.md`
- 详细项目事实、约束、里程碑、当前状态写入 `30-Projects/`
- 可复用的关键取舍写入 `21-Memory/decisions/`

### 约束

- `21-Memory/projects.md` 只做轻量项目 mapping，不记录详细项目内容
- 不要保存整段聊天逐字稿
- 不要把临时调试输出、未确认猜测、一次性命令结果写入长期记忆
- 如果没有明显相关的 session，创建新的 session note，而不是复用无关内容
