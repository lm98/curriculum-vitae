// ─────────────────────────────────────────────────────────────
//  themes/sidebar.typ — two-column layout.
//  Left: identity, contacts, skills, education.
//  Right: summary, experience, projects, publications.
// ─────────────────────────────────────────────────────────────

#let theme = (
  accent: rgb("#0f766e"),
  ink: rgb("#16191f"),
  muted: rgb("#5b6270"),
  faint: rgb("#dfe4e8"),
  side-bg: rgb("#f2f5f5"),
  chip: rgb("#ffffff"),
  sans: "Inter",
  display: "Inter Display",
  mono: "JetBrains Mono",
  body-size: 9pt,
  side-width: 6.1cm,
  margin: 1.2cm,
)

#let md(s) = eval(s, mode: "markup")

#let section(title) = {
  v(1.0em, weak: true)
  block(sticky: true, below: 0.7em, {
    text(font: theme.mono, size: 7.6pt, weight: "medium", fill: theme.accent,
      tracking: 0.14em, upper(title))
    v(0.3em)
    line(length: 1.6em, stroke: 1.4pt + theme.accent)
  })
}

// ── Sidebar blocks ──────────────────────────────────────────
#let side-contacts(contacts) = {
  set text(font: theme.mono, size: 7.4pt)
  stack(spacing: 0.65em, ..contacts.map(c =>
    if "url" in c { link(c.url, c.label) } else { text(fill: theme.muted, c.label) }))
}

#let chip(t) = box(
  fill: theme.chip, stroke: 0.5pt + theme.faint, radius: 2pt,
  inset: (x: 0.4em, y: 0.25em), outset: (y: 0.05em),
  text(font: theme.mono, size: 6.8pt, fill: theme.ink, t),
)

#let side-skills(items) = {
  for s in items {
    block(below: 0.9em, {
      text(size: 7.6pt, weight: "semibold", fill: theme.muted, s.area)
      v(0.35em)
      if s.area == "Spoken" {
        text(size: 8.4pt, s.items)
      } else {
        set par(leading: 0.9em)
        s.items.split(", ").map(chip).join(h(0.25em))
      }
    })
  }
}

#let side-education(items) = {
  for e in items {
    block(below: 0.95em, {
      text(weight: "semibold", size: 8.8pt, e.degree)
      linebreak()
      text(fill: theme.accent, weight: "medium", size: 8.4pt, e.org)
      linebreak()
      text(font: theme.mono, size: 7.2pt, fill: theme.muted, e.dates)
      v(0.3em)
      text(size: 8pt, fill: theme.muted, md(e.note))
    })
  }
}

// ── Main column blocks ──────────────────────────────────────
#let experience(items) = {
  for e in items {
    block(below: 0.95em, {
      block(sticky: true, below: 0.5em, grid(
        columns: (1fr, auto),
        row-gutter: 0.35em,
        text(weight: "semibold", size: 10pt, e.role),
        text(font: theme.mono, size: 7.4pt, fill: theme.muted, e.dates),
        text(weight: "medium", fill: theme.accent, e.org),
        text(font: theme.mono, size: 7.4pt, fill: theme.muted, e.location),
      ))
      list(..e.bullets.map(md))
    })
  }
}

#let projects(items) = {
  for p in items {
    block(breakable: false, below: 0.85em, {
      grid(
        columns: (1fr, auto),
        text(weight: "semibold", size: 9.6pt,
          if "url" in p { link(p.url)[#p.name #text(fill: theme.accent, size: 0.85em)[↗]] } else { p.name }),
        text(font: theme.mono, size: 7pt, fill: theme.accent, p.tags.join(" · ")),
      )
      v(0.35em, weak: true)
      md(p.desc)
    })
  }
}

#let publications(items, me: "L. Micelli") = {
  for p in items {
    block(below: 0.75em, {
      let parts = p.authors.split(me)
      text(weight: "medium", p.title)
      linebreak()
      text(size: 8.3pt, fill: theme.muted, {
        parts.join(text(weight: "semibold", fill: theme.ink, me))
        [ — ]
        emph(p.venue)
        [, #p.year]
        if "doi" in p {
          [ · ]
          link("https://doi.org/" + p.doi,
            text(font: theme.mono, size: 7.2pt, fill: theme.accent)[doi:#p.doi])
        }
      })
    })
  }
}

// ── Full document ───────────────────────────────────────────
#let render(cv) = {
  set document(title: cv.name + " — CV", author: cv.name)
  set page(
    paper: "a4",
    margin: (
      left: theme.side-width + theme.margin,
      right: theme.margin, top: theme.margin, bottom: theme.margin,
    ),
    background: place(left + top,
      rect(width: theme.side-width, height: 100%, fill: theme.side-bg)),
  )
  set text(font: theme.sans, size: theme.body-size, fill: theme.ink, lang: "en")
  set par(leading: 0.55em, spacing: 0.7em)
  set list(
    marker: text(fill: theme.accent, size: 0.8em, baseline: -0.05em)[■],
    indent: 0.1em, body-indent: 0.6em, spacing: 0.5em,
  )

  // The sidebar is placed on page 1, inside the tinted band.
  place(top + left, dx: -theme.side-width - 0.05cm + 0.75cm, dy: 0cm,
    block(width: theme.side-width - 1.35cm, {
      text(font: theme.display, weight: "bold", size: 21pt, tracking: -0.02em,
        par(leading: 0.3em, cv.name.split(" ").join(linebreak())))
      v(0.4em)
      text(font: theme.mono, size: 8pt, fill: theme.accent, weight: "medium",
        cv.headline.replace(" · ", "\n"))
      v(1.2em)
      side-contacts(cv.contacts)
      section("Skills")
      side-skills(cv.skills)
      section("Education")
      side-education(cv.education)
    }))

  // Main column
  text(size: 9.4pt, md(cv.summary))
  section("Experience")
  experience(cv.experience)
  section("Projects")
  projects(cv.projects)
  section("Publications")
  publications(cv.publications)
}
