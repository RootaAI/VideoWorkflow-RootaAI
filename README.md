# OpenMontage AI Video Workflow

一套给新手使用的 Windows + Codex 视频制作工作流。你只需要告诉 Codex 想做什么视频，它会先检查现有 OpenMontage 环境，再引导你完成选题、文案、分镜、素材、配音、字幕、音乐、预览与验收。

本仓库不包含 OpenMontage、FFmpeg、Python、Node.js、模型、素材或密钥，也不会在环境检查时自动安装任何东西。

## 最短使用方法

1. 单独安装并验证 [OpenMontage](https://github.com/calesthio/OpenMontage)。
2. 下载或克隆本仓库，用 Codex 打开仓库根目录。
3. 对 Codex 说：`帮我做一个适合小红书的60秒不出镜知识视频。`
4. Codex 会读取 `AGENTS.md`，找到 OpenMontage 并运行只读体检。
5. 如果显示“核心环境已就绪”，直接回答它提出的内容问题；缺少可选能力不会阻止可行方案。

自动定位失败时，把 OpenMontage 的绝对路径告诉 Codex，或手动检查：

```powershell
.\scripts\preflight.ps1 -OpenMontagePath 'D:\path\to\OpenMontage'
```

## 你会得到什么

- 五类视频方向与选择建议；
- 面向关注、收藏、学习或转化的文案结构；
- 自动拆分镜头的方法和不出镜节奏规则；
- 素材搜索、筛选与授权记录；
- 中文配音、字幕、音乐、横竖版和安全区建议；
- FFmpeg、Remotion、HyperFrames 的选择依据；
- 预览、抽帧、响度、编码和最终验收清单。

真正的视频生产仍由 OpenMontage 的管线、工具注册表和阶段检查点执行。本仓库负责让 Codex 先理解目标、做出可解释的选择，并带领新手走完整个过程。

## 状态含义

- `ready`：检测到的核心与可选合成环境都可用。
- `ready_with_limits`：已经有可运行的制作路径，但某些可选能力不可用；可以继续。
- `blocked`：OpenMontage 无法运行或没有可用合成路径，需要先处理阻塞项。

如果系统 PATH 中找不到 `python`，但 OpenMontage 自己的 `.venv` 可以运行，工作流仍会继续。某个可选运行时显示 `false` 只表示 OpenMontage 注册表未确认它可用；Codex 会结合警告判断它是未安装、包解析失败还是网络检查受限。

## 隐私与费用

环境体检不会读取或输出密钥值。安装软件、配置凭据、调用付费生成服务、下载大型模型或更换已批准的制作路径之前，Codex 必须先说明影响并获得明确同意。
