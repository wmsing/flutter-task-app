# Portfolio pair — master plan

**对外一句话（两个 repo README 首段、GitHub Pin 描述共用）：**  
Flutter client + Go REST API，本地可跑通 CRUD 子集（list / create / complete）。

两个独立 GitHub repo，互相在 README 里链到对方；Profile 各 Pin 一个，Pin 文案里写 **pair**。

---

## 领域边界

| 在范围内 | 明确不做（Out of scope） |
|----------|-------------------------|
| 拉列表、新建、标记完成 | 登录 / 注册 / JWT / 多用户 |
| 内存存储，进程内持久 | Postgres、支付、推送 |
| 本地开发联调 | Phase 1 不上线 hosted API |

**Task / Complete 约定（与 `CONTEXT.md` 一致）：**

- 已完成任务再次 `PATCH …/complete` → **200**，返回同一 Task（幂等）。
- 无 edit 标题、delete、uncomplete。
- 客户端需处理网络/API 错误（统一 JSON 错误体）。

**Demo 入口：** 打开 App 即任务列表，无登录页（Option A）。

---

## 质量门槛（干净感靠这些，不是堆功能）

### 目录

- **Go：** `cmd/server` + `internal/handlers` + `internal/store`（+ `internal/models` 若需要）
- **Flutter：** `lib/core/api_client.dart` + `lib/features/tasks/*`

### README

- 雇主 **2 分钟内** 能跑通：步骤编号、复制即用的 `curl` / `flutter run`
- Go README：Endpoints 表 + 链到 Flutter repo
- Flutter README：改 base URL 说明 + 链到 Go repo

### 仓库卫生

- 正常 `.gitignore`（Dart/Flutter、Go bin、IDE）
- 无密钥、无 `bin/` 提交、无本机绝对路径
- 无半截注释、无 `TODO: fix later`

### 静态检查

- Go：`go fmt`、`go vet` 通过；`go test ./...` 至少覆盖 store + handler 各 1–2 个
- Flutter：`flutter analyze` **零 error**（warning 尽量清）；可选 1 个轻量 widget test

### API 错误

- 非 2xx 统一 JSON：`{"error":"..."}`，禁止裸 500 纯文本
- 命名与文件组织一致（handler / store / model 对齐）

---

## 1) Repo: `flutter-task-app`（本 workspace 可先在此落地）

打开即列表；新增、完成；通过 `core/api_client` 调 Go API。

```
flutter-task-app/
  CONTEXT.md
  lib/
    main.dart
    app.dart
    core/
      api_client.dart
    features/
      tasks/
        task_model.dart
        task_api.dart
        task_list_page.dart
  pubspec.yaml
  README.md
  screenshots/
    list.png
    complete.png          # 可选第二张
```

**README 必含：**

1. 对外一句话 + **Pair:** 链到 `go-tasks-api`
2. Screenshots
3. Stack: Flutter / Dart
4. Run（≤2 min）：先起 Go → `flutter pub get` → 配置 base URL（默认 `http://localhost:8080`）→ `flutter run`
5. Features: list / create / complete
6. Note: portfolio sample, not production

---

## 2) Repo: `go-tasks-api`（独立 repo，与 Flutter 并列）

```
go-tasks-api/
  CONTEXT.md              # 与 Flutter 同 glossary，可互相 copy 或各维护一份
  cmd/
    server/
      main.go
  internal/
    handlers/
      tasks.go
    models/
      task.go
    store/
      memory.go
  go.mod
  README.md
  .env.example            # 仅 PORT=8080
```

**Endpoints：**

| Method | Path | 说明 |
|--------|------|------|
| GET | `/health` | 存活 |
| GET | `/tasks` | 列表 |
| POST | `/tasks` | 创建 `{ "title": "..." }` |
| PATCH | `/tasks/:id/complete` | 标记完成（幂等） |

**README 必含：** 对外一句话、Run、`curl` 示例、Endpoints 表、**Pair:** 链到 `flutter-task-app`。

---

## 发布顺序（Phase 1 = local only）

1. 建 `go-tasks-api`，本地 `curl` 全通，`go test` / `go vet` 绿
2. 建 `flutter-task-app`，模拟器联调，`flutter analyze` 零 error，截图进 `screenshots/`
3. 两个 repo push；Profile Pin，描述写 pair
4. Upwork / LinkedIn 链到两个 repo（或 Profile）

**Phase 2（以后再说，不写进 Phase 1 scope）：** Fly/Render 托管 API、可选 docker-compose。

---

## 工作量

半天到一天。干净 > 花哨。

**状态：** Flutter 与 `../go-tasks-api` 已 scaffold；本地联调：`go run ./cmd/server` → `flutter run`。
