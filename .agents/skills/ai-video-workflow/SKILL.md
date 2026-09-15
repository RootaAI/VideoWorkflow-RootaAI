---
name: ai-video-workflow
description: Use when a beginner wants to plan or produce a faceless knowledge video, software tutorial, promotional video, training video, or cinematic montage with Codex and an existing OpenMontage installation.
---

# AI Video Workflow

Turn a plain-language goal into an approved, reproducible OpenMontage production. A working path is enough to begin; optional providers are choices, not automatic blockers.

## Start with facts

Run `scripts/preflight.ps1 -OpenMontagePath '<path>' -Json` from the repository root.

- `ready` or `ready_with_limits`: state the usable composition runtimes, summarize relevant capability counts, mention warnings once, and continue.
- `blocked`: explain the failed core checks. Do not install, download, edit credentials, change PATH, or switch to a materially different approach without explicit approval.

Never reveal credential values. Never describe an optional feature as installed unless the OpenMontage registry reports it available.

## Guide the beginner

Ask one short question at a time, using this order only as needed:

1. What result should the video create: attention, saves, learning, trust, or conversion?
2. Who is it for and where will it be published?
3. What source material already exists: topic, article, screen recording, footage, images, or reference video?
4. Desired duration, language, aspect ratio, narration, and deadline?

Then read [video-types.md](references/video-types.md), recommend one primary format and one alternative, and explain the tradeoff. Do not make the user choose from a raw tool list.

## Build the production contract

Create these artifacts in a new project workspace and pause for approval after each creative gate:

1. Brief: promise, hook, audience, platform, duration, format, and CTA.
2. Script: narration plus on-screen text.
3. Storyboard: every shot has a job, duration, source, transition, and audio cue.
4. Asset plan: provenance, licensing, generation cost, and missing items.
5. Preview and QA report.

Read [script-and-storyboard.md](references/script-and-storyboard.md) for writing and shot design. Read [assets-and-licensing.md](references/assets-and-licensing.md) before acquiring assets. Read [audio-format-and-qa.md](references/audio-format-and-qa.md) before choosing composition, producing narration, or delivering.

## Hand off to OpenMontage

OpenMontage's `AGENT_GUIDE.md`, selected `pipeline_defs/*.yaml`, stage director skills, registry, checkpoints, and human gates are authoritative for production. Use its pipeline system; do not replace it with ad-hoc generation scripts.

Before paid generation or a consequential call, name the provider, model, reason, estimated cost, and whether it is a sample. Ask for explicit approval before installing dependencies, using paid services, changing provider/runtime, or accepting a lower-quality fallback.

Preserve original media. Keep generated files inside the new project's directories. State truthfully whether assets were user-supplied, licensed stock, AI-generated elsewhere, or composed by OpenMontage.

