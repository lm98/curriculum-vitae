// ─────────────────────────────────────────────────────────────
//  template.typ — layout and styling only.
//  Content lives in cv.yaml; tweak the theme dictionary below
//  to change colors, fonts and spacing globally.
// ─────────────────────────────────────────────────────────────

#let theme = (
  accent: rgb("#0f766e"),   // deep teal
  ink: rgb("#16191f"),
  muted: rgb("#5b6270"),
  faint: rgb("#e3e6ea"),
  chip: rgb("#eef6f5"),
  sans: "Inter",
  display: "Inter Display",
  mono: "JetBrains Mono",
  body-size: 9.4pt,
)

// Inline Typst markup coming from YAML strings.
#let md(s) = eval(s, mode: "markup")

// ── Page and base typography ────────────────────────────────
#let setup(name: "", body) = {
  set document(title: name + " — CV", author: name)
  set page(
    paper: "a4",
    margin: (x: 1.55cm, top: 1.35cm, bottom: 1.5cm),
    footer: context {
      set text(font: theme.mono, size: 7pt, fill: theme.muted)
      grid(
        columns: (1fr, auto),
        name,
        [#counter(page).display() / #counter(page).final().first()],
      )
    },
  )
  set text(font: theme.sans, size: theme.body-size, fill: theme.ink, lang: "en")
  set par(justify: false, leading: 0.55em, spacing: 0.7em)
  show link: set text(fill: theme.ink)
  set list(
    marker: text(fill: theme.accent, size: 0.8em, baseline: -0.05em)[■],
    indent: 0.1em,
    body-indent: 0.6em,
    spacing: 0.5em,
  )
  body
}

// ── Header ──────────────────────────────────────────────────
#let header(name, headline, contacts) = {
  text(font: theme.display, weight: "bold", size: 25pt, tracking: -0.02em, name)
  v(-0.55em)
  text(font: theme.mono, size: 9.5pt, fill: theme.accent, weight: "medium", headline)
  v(0.1em)
  let items = contacts.map(c => {
    if "url" in c { link(c.url, c.label) } else { c.label }
  })
  text(font: theme.mono, size: 7.6pt, fill: theme.muted,
    items.join(h(0.45em) + text(fill: theme.accent)[/] + h(0.45em)))
  v(0.35em)
}

// ── Section heading ─────────────────────────────────────────
#let section(title) = {
  v(0.9em, weak: true)
  block(sticky: true, below: 0.75em, grid(
    columns: (auto, 1fr),
    column-gutter: 0.6em,
    align: horizon,
    text(font: theme.mono, size: 8pt, weight: "medium", fill: theme.accent,
      tracking: 0.12em, upper(title)),
    line(length: 100%, stroke: 0.6pt + theme.faint),
  ))
}

// ── Generic dated entry (experience, education) ─────────────
#let entry(title, org, location, dates, body) = block(breakable: true, below: 1.05em, {
  block(sticky: true, below: 0.5em, grid(
    columns: (1fr, auto),
    row-gutter: 0.35em,
    text(weight: "semibold", size: 10.3pt, title),
    text(font: theme.mono, size: 7.8pt, fill: theme.muted, dates),
    text(weight: "medium", fill: theme.accent, org),
    text(font: theme.mono, size: 7.8pt, fill: theme.muted, location),
  ))
  body
})

#let experience(items) = {
  for e in items {
    entry(e.role, e.org, e.location, e.dates,
      list(..e.bullets.map(md)))
  }
}

#let education(items) = {
  for e in items {
    block(below: 0.8em, {
      grid(
        columns: (1fr, auto),
        text(weight: "semibold", size: 10pt, e.degree) + h(0.5em) + text(fill: theme.accent, weight: "medium", e.org),
        text(font: theme.mono, size: 7.8pt, fill: theme.muted, e.dates + " · " + e.location),
      )
      v(0.35em, weak: true)
      text(fill: theme.muted, md(e.note))
    })
  }
}

// ── Projects ────────────────────────────────────────────────
#let chip(t) = box(
  fill: theme.chip, radius: 2pt, inset: (x: 0.4em, y: 0.22em), baseline: 0.2em,
  text(font: theme.mono, size: 6.8pt, fill: theme.accent, t),
)

#let projects(items) = {
  for p in items {
    block(breakable: false, below: 0.95em, {
      block(below: 0.45em, {
        text(weight: "semibold", size: 10pt,
          if "url" in p { link(p.url)[#p.name #text(fill: theme.accent, size: 0.85em)[↗]] } else { p.name })
        h(0.7em)
        p.tags.map(chip).join(h(0.3em))
      })
      md(p.desc)
    })
  }
}

// ── Publications ────────────────────────────────────────────
#let publications(items, me: "L. Micelli") = {
  let n = items.len()
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.75em,
    ..items.enumerate().map(((i, p)) => (
      text(font: theme.mono, size: 7.8pt, fill: theme.accent)[[#(n - i)]],
      {
        let authors = p.authors.replace(me, "§ME§")
        let parts = authors.split("§ME§")
        parts.map(x => text(fill: theme.muted, x)).join(text(weight: "semibold", me))
        if not p.authors.ends-with(".") [.]
        [ ]
        text(weight: "medium")[#p.title.]
        [ ]
        emph(p.venue)
        [, #p.year.]
        if "doi" in p {
          [ ]
          link("https://doi.org/" + p.doi,
            text(font: theme.mono, size: 7.4pt, fill: theme.accent)[doi:#p.doi])
        }
      },
    )).flatten(),
  )
}

// ── Skills ──────────────────────────────────────────────────
#let skills(items) = grid(
  columns: (auto, 1fr),
  column-gutter: 1.1em,
  row-gutter: 0.6em,
  ..items.map(s => (
    text(font: theme.mono, size: 7.8pt, fill: theme.muted, s.area),
    s.items,
  )).flatten(),
)

#let summary(s) = block(below: 0.2em, text(size: 9.6pt, md(s)))
