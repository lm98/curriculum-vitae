# CV — Leonardo Micelli

Source of my CV, written in [Typst](https://typst.app).

| File | What it is |
|---|---|
| `cv.yaml` | **All the content.** Edit this to update the CV. |
| `template.typ` | Layout and styling (colors, fonts, spacing live in the `theme` dictionary at the top). |
| `cv.typ` | Entry point: loads the YAML and decides the section order. |
| `fonts/` | Vendored fonts (Inter, JetBrains Mono — both SIL OFL) so builds are identical everywhere. |

## Build

Requires Typst ≥ 0.13 (`cargo install typst-cli`, `brew install typst`, or a release binary).

```sh
make          # → cv.pdf
make watch    # recompile on save
make preview  # PNG pages in preview/
```

Text fields in `cv.yaml` accept inline Typst markup: `*bold*`, `_italic_`,
`#link("https://…")[label]`.

## Releases

Every push builds the PDF as a workflow artifact. Pushing a tag (`git tag v2026.09 && git push --tags`)
attaches `Leonardo_Micelli_CV.pdf` to a GitHub Release, giving a stable download link.
