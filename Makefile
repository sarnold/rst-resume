BASE        = resume

PDFOUT      = $(BASE).pdf
HTMLOUT     = $(BASE).html
TXTOUT      = $(BASE).txt

RSTINCLUDE  = utils.rst
LATEXSTYLE  = mystyle.tex
CSSSTYLE    = resume.css

PDF         = pdflatex
RST2LATEX   = rst2latex.py
RST2HTML    = rst2html.py
HTMLLINKCSS = --link-stylesheet
RSTHTMLOPTS = --stylesheet=$(CSSSTYLE) --strip-comments

RSTLATEXOPTS= --stylesheet=$(LATEXSTYLE) \
			  --table-style=nolines \
			  --use-latex-docinfo  \
			  --strip-comments

PDFOPTS     =

all: $(PDFOUT) $(HTMLOUT) $(TXTOUT)

%.pdf: %.tex $(LATEXSTYLE)
	$(PDF) $(PDFOPTS) $<
	$(RM) $@
	$(PDF) $(PDFOPTS) $<

%.html: %.rst $(RSTINCLUDE)
	perl -ple '$$_ .= <> if /^\d{4}/; chomp;' $< | $(RST2HTML) $(RSTHTMLOPTS) $(HTMLLINKCSS) > $@

%.txt: %.rst plaintext.sh
	./plaintext.sh < $< > $@

%.tex: %.rst $(RSTINCLUDE)
	$(RST2LATEX) $(RSTLATEXOPTS) $< $@
	sed -i 's/LaTeX/\\latex{}/g;s/TeX/\\TeX{}/g' $@

# sed -ri 's/\b[A-Z]{3,}\b/\\textsc{\L\0}/g' $@

