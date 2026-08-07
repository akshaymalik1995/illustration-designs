# Illustration Designs

A library of illustration style prompts, hosted on GitHub Pages and consumed by a ChatGPT custom GPT via an Action.

- `styles/*.md` — one art-direction prompt per style (16 styles)
- `index.json` — style catalog (id, name, tagline)
- `openapi.yaml` — Action schema for the GPT (paste into GPT editor → Actions)

How it works: in the GPT you say "isometric: a cat doing backup". The GPT calls
`getStyle(isometric)`, silently loads that one style prompt, and generates the image.
Say "styles" to have it call `listStyles` and show the menu.

Hosted at: https://akshaymalik1995.github.io/illustration-designs/
