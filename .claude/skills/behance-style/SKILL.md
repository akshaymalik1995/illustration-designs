---
name: behance-style
description: Turn a Behance gallery into a library style — download its illustrations locally as references (never published), distill the design language into a style prompt, add it to the gallery site, and produce an on-style thumbnail via ChatGPT using a reference image. Use when the user gives a Behance URL, says "add this style", "/behance-style", or wants illustrations "in the style of" some Behance project.
---

# Behance → Style Library pipeline

Repo: `D:\Code\illustration-designs` → https://akshaymalik1995.github.io/illustration-designs/
GPT: "Illustration Studio" (editor: chatgpt.com/gpts/editor/g-6a75a00fd0dc81918cd5c0a7526f68b2)

Input: a Behance gallery URL (optionally a style name). Output: references downloaded, `styles/<id>.md`, `index.json` entry, `img/<id>.jpg` thumbnail, pushed.

## 1. Study the gallery

Open the URL with claude-in-chrome, screenshot, scroll 2–3 times, screenshot again.
Read the visual system: shape construction, palette, linework, texture, lighting, composition, recurring motifs, mood.
Pick a kebab-case id (e.g. `kpop-idol-gloss`).

## 2. Download references (LOCAL ONLY — copyrighted)

In the Behance tab, collect artwork URLs via javascript_tool:
```js
[...new Set([...document.querySelectorAll('img')].map(i=>i.src).filter(s=>s.includes('project_modules')))]
```
Download each with Invoke-WebRequest into `references/<id>/01.jpg, 02.jpg, ...`
Write `references/<id>/SOURCE.txt` with the gallery URL + artist name.
`references/` is in `.gitignore` — NEVER commit or publish these images.

## 3. Distill the style prompt

Write `styles/<id>.md` in the house format:
- Title line + one-sentence framing
- "Construction rules" / "Every image must feature" bullet list — concrete visual mechanics, not vibes
- Mood line
- A STRICTLY FORBIDDEN block naming the most likely model drift (learned: glossy/glow language drifts to photoreal anime — assert "stylized vector, graphic space, not a real place" hard and forbid photorealism, real skies, depth of field explicitly)

## 4. Register + publish

Add to `index.json` under the "Behance Curated" section: `{id, name, tagline, file}`.
`git add -A; git commit; git push`. Wait for Pages deploy:
`until curl -sf <style-url> | grep -q <marker>; do sleep 15; done`

## 5. Thumbnail (standard subject: "a person watering a small plant on a balcony at sunrise. No text in the image. Landscape orientation.")

PREFERRED — reference-image method (most faithful):
1. Copy the best reference image into the session scratchpad (file_upload only accepts session-shared paths).
2. On chatgpt.com: find the file input (`find` tool), `file_upload` the reference.
3. Insert prompt into `#prompt-textarea` (contenteditable — use `document.execCommand('insertText', ...)` after focus+selectAll), text: "This image is a style reference. Create a new illustration in EXACTLY this illustration style — same construction, same palette, same background language. Subject: <standard subject>". Click `[data-testid="send-button"]`.

FALLBACK — GPT action method: message the Illustration Studio GPT with
`Call the getStyle action with styleId "<id>". Confirm the fetch, then plan (don't generate): <subject>` then `CREATE THE ILLUSTRATION`.
(Naming the action explicitly in the user message is what makes the fetch reliable.)

Collect the image:
- Poll `[data-testid="stop-button"]` until gone (3s intervals, keep each JS call under ~40s).
- Click the generated image → viewer opens → click the download icon in the top bar (~1458,27).
- Move the newest `*.png` from `~/Downloads` to `img/<id>.png`.
- Convert to 800px jpg (System.Drawing, quality 85), delete the png, push.

## 6. Verify

Read `img/<id>.jpg` and compare against the references. If the style drifted, tighten the FORBIDDEN block in the style file and regenerate. A fix invalidates the previous check — re-compare after every change.
