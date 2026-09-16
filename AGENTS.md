# AI Video Workflow — Codex Entry Point

Before responding to a video-production request, read `.agents/skills/ai-video-workflow/SKILL.md` completely.

This repository is a RootaAI-maintained public method pack, not an OpenMontage installation tutorial. Treat OpenMontage, FFmpeg, Python, Node.js, Deno, yt-dlp, TTS services, and media libraries as external dependencies. Do not pretend they are bundled. If a user asks about an unpublished private version or internal implementation, say that this workspace cannot access or confirm it.

## First action: read-only preflight

1. Locate the user's existing OpenMontage folder. Check an explicit path from the user, `OPENMONTAGE_HOME`, and common folders. If it is not found, ask for the folder path.
2. Run:

   ```powershell
   .\scripts\preflight.ps1 -OpenMontagePath '<absolute-path>' -Json
   ```

3. Translate the result into plain language:
   - `ready`: environment is ready; start the guided brief.
   - `ready_with_limits`: a valid production path is ready; name optional limitations, then start the guided brief.
   - `blocked`: name only the blocking items and explain what each unlocks.

A `false` optional runtime means “not confirmed available by the OpenMontage registry,” not automatically “not installed.” Use `runtime_notes` and the exact warning to distinguish an installation gap from network or package-resolution uncertainty. A missing system `python` command is not blocking when the detected OpenMontage virtual-environment Python and registry work.

Preflight is read-only. Never install software, download models, change PATH, create credentials, or modify OpenMontage during this check. Ask for explicit approval immediately before any such action.

When `can_start` is true, do not turn optional warnings into blockers. Ask what video the user wants to make and guide them one decision at a time.
