# 面试通

面试通是一个面向求职者和面试训练场景的 AI 面试辅助平台。项目提供简历解析、岗位 JD 分析、面试题生成、模拟追问、面试报告、题库练习以及管理后台能力，适合用于个人面试准备、训练平台原型或企业内部候选人辅导场景。

## 功能特性

用户端：

- 账号注册、登录、退出登录和个人资料维护
- 简历上传、解析与历史版本管理
- 岗位 JD 分析，提取关键词、核心技能、面试关注点和改进建议
- 基于简历、岗位和难度生成面试题
- 模拟面试，支持回答评分、AI 追问和会话结束
- 面试报告查看、收藏错题、错题重练和 PDF 导出
- 热门题库浏览、收藏、练习和上传自有题库
- 总览仪表盘与历史记录追踪

管理端：

- 用户列表、启停用户、目标岗位维护和管理员升级
- 简历、面试记录、报告与 AI 调用日志查看
- Prompt 模板管理
- 限流、上传、输入长度、注入检测等风控配置
- 敏感词配置和审核内容管理
- 管理员个人中心

## 技术栈

后端：

- Java 17
- Spring Boot 3.4.2
- Spring Security + JWT
- Spring AI OpenAI 兼容接口
- MyBatis-Plus
- MySQL 8
- Redis 7
- Knife4j / Springdoc OpenAPI

前端：

- Vue 3
- Vue Router 4
- Pinia
- Element Plus
- Axios
- Vite 6

部署：

- Docker / Docker Compose
- Nginx 反向代理

## 项目结构

```text
mianshitong/
├─ src/                       # Spring Boot 后端源码
│  └─ main/
│     ├─ java/com/mianshitong/project/
│     └─ resources/
│        ├─ application.yml   # 通用配置
│        ├─ application-dev.yml
│        ├─ application-prod.yml
│        ├─ schema.sql        # 表结构初始化
│        └─ data.sql          # 基础数据初始化
├─ web/                       # Vue 3 前端源码
├─ nginx/                     # Nginx 配置
├─ Dockerfile                 # 后端镜像构建
├─ docker-compose.yml         # 本地/服务器编排
├─ .env.example               # 环境变量模板
└─ README.md
```

## 环境要求

- JDK 17+
- Maven 3.9+
- Node.js 18+，推荐 20 或 22
- MySQL 8.x
- Redis 7.x
- Docker 与 Docker Compose，可选

## 配置说明

首次运行建议复制环境变量模板：

```bash
cp .env.example .env
```

核心环境变量：

| 变量 | 说明 |
| --- | --- |
| `SPRING_PROFILES_ACTIVE` | Spring 运行环境，开发默认 `dev`，Docker 部署使用 `prod` |
| `JWT_SECRET` | JWT 签名密钥；开发环境可留空，生产环境必须设置不少于 32 字节的随机字符串 |
| `CORS_ALLOWED_ORIGINS` | 跨域白名单，多个地址用英文逗号分隔 |
| `MYSQL_URL` | MySQL JDBC 地址，默认库名为 `mianshitong` |
| `MYSQL_USERNAME` / `MYSQL_PASSWORD` | MySQL 账号和密码 |
| `MYSQL_ROOT_PASSWORD` | Docker MySQL root 密码 |
| `NVIDIA_OPENAI_BASE_URL` | OpenAI 兼容接口基础地址 |
| `NVIDIA_API_KEY` | AI 服务 API Key |
| `NVIDIA_MODEL` | AI 模型名称 |
| `LOGIN_MAX_FAILURES` | 登录失败次数阈值 |
| `LOGIN_FAIL_WINDOW_MINUTES` | 登录失败统计窗口 |
| `LOGIN_LOCK_MINUTES` | 登录锁定时长 |
| `AUTO_MIGRATE_LEGACY_PASSWORDS` | 是否自动迁移历史明文密码为 BCrypt |

前端可选环境变量：

| 变量 | 默认值 | 说明 |
| --- | --- | --- |
| `VITE_API_BASE_URL` | `/api` | 前端请求后端 API 的基础路径 |
| `VITE_API_TIMEOUT` | `120000` | 普通接口超时时间，单位毫秒 |
| `VITE_AI_API_TIMEOUT` | `300000` | AI 相关接口超时时间，单位毫秒 |
| `VITE_DEV_API_PROXY_TARGET` | `http://127.0.0.1:8080` | Vite 开发代理目标 |

## 本地开发

### 1. 准备数据库和 Redis

如果本机已经安装 MySQL 与 Redis，请先创建数据库：

```sql
CREATE DATABASE mianshitong DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

也可以用 Docker 只启动基础依赖：

```bash
docker compose up -d mysql redis
```

### 2. 启动后端

```bash
mvn spring-boot:run
```

后端默认监听 `http://localhost:8080`。

开发环境说明：

- 默认激活 `dev` 配置
- `dev` 环境会自动执行 `schema.sql` 和 `data.sql`
- `dev` 环境未配置 `JWT_SECRET` 时会自动生成临时密钥，重启后旧 Token 会失效
- 接口文档入口：`http://localhost:8080/doc.html` 或 `http://localhost:8080/swagger-ui/index.html`

### 3. 启动前端

```bash
cd web
npm install
npm run dev
```

前端默认监听 `http://localhost:5173`，开发服务器会把 `/api` 代理到 `http://127.0.0.1:8080`。

## Docker 部署

准备 `.env` 后执行：

```bash
docker compose up --build -d
```

默认访问地址：

- 前端：`http://localhost`
- 后端 API：`http://localhost:8080/api`

Docker 部署说明：

- `web` 容器使用 Nginx 托管前端静态资源
- Nginx 会将 `/api/*` 反向代理到 `backend:8080`
- 后端容器使用 `prod` 配置
- `prod` 环境默认不自动初始化 SQL，请在正式部署前完成数据库结构和基础数据准备
- 生产环境必须设置高强度 `JWT_SECRET`、数据库密码和 AI 服务密钥

## 管理员初始化

项目不内置公开默认管理员账号。首次部署时可以先注册普通用户，再通过数据库提升角色：

```sql
UPDATE xz_user
SET role = 'ADMIN'
WHERE email = 'your-email@example.com';
```

登录后即可访问管理端菜单。已有管理员也可以在管理端用户列表中将普通用户升级为管理员。

## 常用命令

后端编译：

```bash
mvn -DskipTests compile
```

后端打包：

```bash
mvn -DskipTests package
```

前端构建：

```bash
cd web
npm run build
```

查看容器日志：

```bash
docker compose logs -f backend
docker compose logs -f web
```

停止服务：

```bash
docker compose down
```

## 安全说明

- 密码使用 BCrypt 存储
- 登录失败会按邮箱和 IP 进行计数与锁定
- 接口使用 JWT 鉴权，退出登录后 Token 会进入 Redis 黑名单
- 每次请求会回查用户状态和角色，禁用用户无法继续访问
- 管理端接口需要 `ADMIN` 角色
- CORS 白名单通过环境变量配置
- 简历和题库上传会校验文件扩展名与文件头
- 支持历史明文密码启动时自动迁移为 BCrypt

## 常见问题

### 前端提示网络错误

- 确认后端 `8080` 端口已启动
- 确认前端 `VITE_API_BASE_URL` 或 Vite 代理配置正确
- 查看浏览器控制台和后端日志

### 后端启动提示 JWT 密钥错误

- 开发环境可以留空 `JWT_SECRET`
- 生产环境必须设置不少于 32 字节的随机字符串
- 不要使用示例值或弱口令作为 JWT 密钥

### Docker 启动失败提示环境变量缺失

- 检查 `.env` 是否存在
- 确认 `MYSQL_ROOT_PASSWORD`、`MYSQL_USERNAME`、`MYSQL_PASSWORD` 等必填变量已设置
- 生产环境还需要配置 `JWT_SECRET`

### AI 功能无响应或返回失败

- 检查 `NVIDIA_API_KEY` 是否有效
- 检查 `NVIDIA_OPENAI_BASE_URL` 和 `NVIDIA_MODEL` 是否与服务商一致
- 适当调大 `VITE_AI_API_TIMEOUT` 或查看后端 AI 调用日志

## 提交规范

建议使用 Conventional Commits 风格，并用中文描述变更内容：

```text
feat: 增加模拟面试报告导出
fix: 修复登录失败锁定逻辑
docs: 更新项目部署说明
refactor: 优化管理端用户服务
chore: 调整构建配置
```

提交前建议至少执行：

```bash
mvn -DskipTests compile
cd web && npm run build
```
