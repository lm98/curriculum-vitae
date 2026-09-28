// Entry point. Pick a theme with:  typst compile --input theme=sidebar cv.typ
// Available: editorial (default), modern, sidebar.
#import "themes/modern.typ" as modern
#import "themes/sidebar.typ" as sidebar
#import "themes/editorial.typ" as editorial

#let themes = (modern: modern.render, sidebar: sidebar.render, editorial: editorial.render)
#let chosen = sys.inputs.at("theme", default: "editorial")

#themes.at(chosen)(yaml("cv.yaml"))
