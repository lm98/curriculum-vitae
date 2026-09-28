// ─────────────────────────────────────────────────────────────
//  themes/editorial.typ — classic single column, serif.
//  Quieter and more "print"-like; small caps section heads.
// ─────────────────────────────────────────────────────────────

#let theme = (
  accent: rgb("#8a2c2c"),   // oxblood
  ink: rgb("#1b1b1b"),
  muted: rgb("#5f5a55"),
  rule: rgb("#cfc8c0"),
  serif: "Source Serif 4",
  display: "Source Serif 4 Display",
  sans: "Inter",
  body-size: 9.8pt,
)

#let md(s) = eval(s, mode: "markup")

#let section(title) = {
  v(1.0em, weak: true)
  block(sticky: true, below: 0.7em, grid(
    columns: (auto, 1fr),
    column-gutter: 0.7em,
    align: horizon,
    text(font: theme.serif, weight: "semibold", size: 10.5pt, fill: theme.accent,
      tracking: 0.08em, smallcaps(lower(title))),
    line(length: 100%, stroke: 0.5pt + theme.rule),
  ))
}

#let dateline(dates, location) = text(style: "italic", size: 9pt, fill: theme.muted,
  dates + if location != none { " · " + location } else { "" })

#let experience(items) = {
  for e in items {
    block(below: 1em, {
      block(sticky: true, below: 0.45em, grid(
        columns: (1fr, auto),
        align: (left + bottom, right + bottom),
        [#text(weight: "semibold", size: 10.6pt, e.role)#h(0.5em)#text(fill: theme.muted)[—]#h(0.5em)#text(style: "italic", e.org)],
        dateline(e.dates, e.location),
      ))
      list(..e.bullets.map(md))
    })
  }
}

#let projects(items) = {
  for p in items {
    block(breakable: false, below: 0.7em, {
      text(weight: "semibold",
        if "url" in p { link(p.url, p.name) } else { p.name })
      h(0.5em)
      text(font: theme.sans, size: 7.2pt, fill: theme.accent, tracking: 0.04em,
        upper(p.tags.join(" · ")))
      [ — ]
      md(p.desc)
    })
  }
}

#let publications(items, me: "L. Micelli") = {
  for p in items {
    block(below: 0.6em, {
      p.authors.split(me).join(text(weight: "semibold", me))
      [. “#p.title.” ]
      emph(p.venue)
      [, #p.year.]
      if "doi" in p {
        [ ]
        link("https://doi.org/" + p.doi, text(fill: theme.accent)[doi:#p.doi])
      }
    })
  }
}

#let skills(items) = grid(
  columns: (auto, 1fr),
  column-gutter: 1.1em,
  row-gutter: 0.55em,
  ..items.map(s => (text(style: "italic", fill: theme.muted, s.area), s.items)).flatten(),
)

#let education(items) = {
  for e in items {
    block(below: 0.7em, {
      grid(
        columns: (1fr, auto),
        [#text(weight: "semibold", e.degree), #text(style: "italic", e.org)],
        dateline(e.dates, e.location),
      )
      v(0.3em, weak: true)
      text(fill: theme.muted, md(e.note))
    })
  }
}

#let render(cv) = {
  set document(title: cv.name + " — CV", author: cv.name)
  set page(paper: "a4", margin: (x: 1.8cm, top: 1.5cm, bottom: 1.5cm),
    footer: context if counter(page).final().first() > 1 {
      set text(size: 8pt, fill: theme.muted, style: "italic")
      align(center, counter(page).display())
    })
  set text(font: theme.serif, size: theme.body-size, fill: theme.ink, lang: "en",
    number-type: "old-style")
  set par(justify: true, leading: 0.55em, spacing: 0.7em)
  set list(marker: text(fill: theme.accent)[–], indent: 0em, body-indent: 0.6em, spacing: 0.45em)

  // Header — centered, typographic
  align(center, {
    text(font: theme.display, weight: "semibold", size: 26pt, cv.name)
    v(-0.3em)
    text(style: "italic", size: 11pt, fill: theme.accent, cv.headline.replace("·", "—"))
    v(0.1em)
    text(size: 8.8pt, fill: theme.muted,
      cv.contacts.map(c => if "url" in c { link(c.url, c.label) } else { c.label })
        .join(h(0.5em) + sym.dot.c + h(0.5em)))
  })
  v(0.4em)
  line(length: 100%, stroke: 0.5pt + theme.rule)
  v(0.1em)
  md(cv.summary)

  section("Experience")
  experience(cv.experience)
  section("Projects")
  projects(cv.projects)
  section("Skills")
  skills(cv.skills)
  section("Publications")
  publications(cv.publications)
  section("Education")
  education(cv.education)
}
