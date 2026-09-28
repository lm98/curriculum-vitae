TYPST ?= typst
THEME ?= modern
FONTS  = --font-path fonts --ignore-system-fonts
FLAGS  = $(FONTS) --input theme=$(THEME)

# Typst compiles in milliseconds, so every target just rebuilds.
.PHONY: all themes watch preview clean

all:
	$(TYPST) compile $(FLAGS) cv.typ cv.pdf

# Build every theme side by side for comparison
themes:
	for t in modern sidebar editorial; do \
		$(TYPST) compile $(FONTS) --input theme=$$t cv.typ cv-$$t.pdf; \
	done

# Recompile on every save (open cv.pdf in a viewer that auto-reloads)
watch:
	$(TYPST) watch $(FLAGS) cv.typ cv.pdf

# PNG previews, handy for diffs in PRs
preview:
	mkdir -p preview && $(TYPST) compile $(FLAGS) --ppi 110 cv.typ "preview/page-{p}.png"

clean:
	rm -rf cv.pdf cv-*.pdf preview
