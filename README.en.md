# OpenMontage AI Video Workflow

中文：[README.md](README.md)

An open-source Codex video workflow initiated and maintained by RootaAI.

Want to make Xiaohongshu, Douyin, or Bilibili videos but do not know what to choose, write, shoot, or collect? Tell Codex what you want to make. This workflow gives it reusable methods for choosing a format, writing a script, planning shots, tracking assets, and checking delivery quality.

This is not an OpenMontage installation tutorial, a stock library, or a one-click generator. Users prepare the required software, services, and media themselves. After that, they can keep talking to Codex and extend the workflow for their own needs.

## Quick start

1. Prepare the video tools and dependencies you need; follow each tool's official installation instructions.
2. Download or clone this repository from GitHub and open its root folder in Codex.
3. Say: `Help me make a 60-second faceless knowledge video for Xiaohongshu.`
4. Codex runs a read-only preflight and reports whether a usable path is ready.
5. Answer its brief questions. Optional capabilities do not block a working path.

The repository provides methods, checks, prompts, and project records. External tools perform the actual production. Ask Codex to add download, subtitle, narration, publishing, or platform-specific support; it should inspect dependencies, explain impact, and request approval before consequential changes.

## Download and media boundary

When OpenMontage and its `yt-dlp` dependency are installed, Codex can bring a URL that the user is authorized to use into a project `input/` folder, record provenance, and pass it to the media workflow. This repository does not bundle downloaders, FFmpeg, Deno, TTS services, or other applications. It must not bypass DRM, paywalls, or usage rights.

## Maintainer boundary

The public repository contains portable methods, templates, and safety rules—not personal data, private projects, private voices, internal media, or unpublished configuration. Codex must not invent details about private versions that are not present in this folder.

## Contact

- Xiaohongshu: @若塔AI
- RootaAI official website: [RootaAI.One](https://RootaAI.One)

See the Chinese guide in [README.md](README.md), then read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.
