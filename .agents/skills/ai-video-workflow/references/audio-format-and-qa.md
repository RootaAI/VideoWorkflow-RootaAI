# Audio, Format, Composition, and QA

## Narration, subtitles, and music

- Test one short TTS sample before producing the full script. Choose a natural voice for the language and audience; do not treat any provider as mandatory.
- Generate narration by sentence or use real timestamps. Subtitle timing must follow speech, not evenly divide a paragraph.
- Prefer 1–2 subtitle lines. Break at meaning boundaries; keep punctuation and technical terms together.
- Start music roughly 16–22 dB below clear speech, then adjust by listening. Duck it further during dense explanation; do not solve masking by crushing narration.
- Use silence or a small level change to mark an important reveal. More effects do not create more clarity.

## Aspect ratio and safe zones

- Vertical social: 1080×1920. Keep essential text inside the central 80% width and away from the top/bottom interface zones; confirm against the target app's current UI with a real phone preview.
- Horizontal: 1920×1080. Keep titles and captions away from the outer 5% and player controls.
- A horizontal screen recording in a vertical video needs an intentional crop, zoomed detail, or redesigned layout. Shrinking the entire desktop is usually unreadable.

## Composition choice

- FFmpeg: reliable for cutting, speed changes, mixing, subtitles, and straightforward assembly.
- Remotion: useful for reusable React motion graphics, data cards, captions, and synthetic UI scenes.
- HyperFrames: useful for bespoke HTML/CSS/GSAP typography, launch reels, and product-style motion.

Use only a runtime reported available by OpenMontage. If multiple runtimes are available, present their brief-specific strengths and tradeoffs and obtain approval before locking the choice.

## Delivery gate

1. Run the OpenMontage preflight and selected pipeline checks.
2. Render a low-cost preview or representative section before the full export.
3. Inspect opening, middle, transition, subtitle-heavy, and ending frames.
4. Watch the complete video with sound. Check cuts, crop, subtitle timing, music masking, claims, and final action.
5. Use `ffprobe`: verify duration, dimensions, frame rate, H.264 video, AAC audio, `yuv420p`, and audio-stream presence unless another delivery spec was approved.
6. Check social speech loudness around -16 LUFS integrated as a starting target, with no clipping; platform and client specifications override this target.
7. Confirm every external asset appears in the license log and originals remain unchanged.
8. Deliver the final file, preview, script, storyboard, provenance log, and QA result with absolute paths.

