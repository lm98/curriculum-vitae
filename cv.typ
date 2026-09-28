// Entry point. Pick a theme with:  typst compile --input theme=sidebar cv.typ
// Available: modern (default), sidebar, editorial.
#import "themes/modern.typ" as modern
#import "themes/sidebar.typ" as sidebar
#import "themes/editorial.typ" as editorial

#let themes = (modern: modern.render, sidebar: sidebar.render, editorial: editorial.render)
#let chosen = sys.inputs.at("theme", default: "modern")

#themes.at(chosen)(yaml("cv.yaml"))
