TYPST ?= typst
FLAGS  = --font-path fonts --ignore-system-fonts

.PHONY: all watch preview clean

all: cv.pdf

cv.pdf: cv.typ template.typ cv.yaml
	$(TYPST) compile $(FLAGS) cv.typ cv.pdf

# Recompile on every save (open cv.pdf in a viewer that auto-reloads)
watch:
	$(TYPST) watch $(FLAGS) cv.typ cv.pdf

# PNG previews, handy for diffs in PRs
preview:
	mkdir -p preview && $(TYPST) compile $(FLAGS) --ppi 110 cv.typ "preview/page-{p}.png"

clean:
	rm -rf cv.pdf preview
