# Release checklist

Before publishing a GitHub release:

- [ ] Run `tests/Test-Repository.ps1`.
- [ ] Run `tests/Test-Preflight.ps1` against a real OpenMontage installation.
- [ ] Run the skill validator against `.agents/skills/ai-video-workflow`.
- [ ] Confirm README links, examples, and supported claims are current.
- [ ] Scan for API keys, cookies, private paths, private projects, voice profiles, and media.
- [ ] Confirm no application binaries, model caches, or `node_modules` are tracked.
- [ ] Confirm third-party notices and licenses are present.
- [ ] Tag a semantic version and summarize user-visible changes in `CHANGELOG.md`.
- [ ] Upload only the Git repository; keep production projects and credentials outside GitHub.

