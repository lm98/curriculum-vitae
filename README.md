# CV — Leonardo Micelli

Source of my CV, written in [Typst](https://typst.app).

| File | What it is |
|---|---|
| `cv.yaml` | **All the content.** Edit this to update the CV. |
| `themes/*.typ` | Layouts: `modern` (default), `sidebar`, `editorial`. Colors, fonts and spacing live in each file's `theme` dictionary. |
| `cv.typ` | Entry point: loads the YAML and renders it with the selected theme. |
| `fonts/` | Vendored fonts (Inter, JetBrains Mono, Source Serif 4 — all SIL OFL) so builds are identical everywhere. |

## Build

Requires Typst ≥ 0.13 (`cargo install typst-cli`, `brew install typst`, or a release binary).

```sh
make          # → cv.pdf
make watch    # recompile on save
make preview  # PNG pages in preview/
make THEME=sidebar   # build with another theme
make themes          # build all themes for comparison
```

Text fields in `cv.yaml` accept inline Typst markup: `*bold*`, `_italic_`,
`#link("https://…")[label]`.

## Releases

Every push builds the PDF as a workflow artifact. Pushing a tag (`git tag v2026.09 && git push --tags`)
attaches `Leonardo_Micelli_CV.pdf` to a GitHub Release, giving a stable download link.
