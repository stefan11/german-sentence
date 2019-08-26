MKINDEX=makeindex -gs index.format   # dfki (German Order)
DVIPS_OPTIONS=-j0 -Pwww
#DVIPS_OPTIONS=-Ppdf

all: german-sentence.pdf

check: check-danish.2.ps

SOURCE=german-sentence-include.tex\
       german-sentence.tex\
       gs-empty-elements.tex\
       gs-introduction.tex\
       gs-mult-fronting.tex\
	gs-informationstructure.tex\
       gs-predication.tex\
       gs-sentence-structure.tex\
	gs-alternatives.tex

.SUFFIXES: .tex


%.ps.gz: %.ps
	cp $*.ps $*.tmp
	gzip $*.tmp
	mv $*.tmp.gz $*.ps.gz

%.2.ps: %.ps
	2up 2 $*.ps >$*.tmp
	sed -e 's/%!PS-Adobe-2.0/%!PS-Adobe-2.0\n%%Orientation: Landscape/' $*.tmp >$*.2.ps
	rm $*.tmp

%.ps: %.dvi
	dvips -Pwww -j0 $*.dvi -o

%.pdf: %.ps
	ps2pdf13 $*.ps

#thumbpdf --modes=ps2pdf complex.pdf



%.pdf: %.tex $(SOURCE)
	xelatex -no-pdf $* |grep -v math
	biber  $*
	xelatex -no-pdf $* |grep -v math
	biber  $*
	xelatex $* -no-pdf |egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'
	correct-toappear
	correct-index
	\rm $*.adx
	authorindex -i -p $*.aux > $*.adx
	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
	makeindex -gs index.format -o $*.and $*.adx.hyp
	makeindex -gs index.format -o $*.lnd $*.ldx
	makeindex -gs index.format -o $*.snd $*.sdx
	xelatex $* | egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'

# idx = author index
# ldx = language
# sdx = subject

# mit biblatex
#	makeindex -gs index.format -o $*.ind $*.idx


#	\rm $*.adx
#	authorindex -i -p $*.aux > $*.adx
#	sed -e 's/}{/|hyperpage}{/g' $*.adx > $*.adx.hyp
#	makeindex -gs index.format -o $*.and $*.adx.hyp
#	xelatex $* | egrep -v 'math|PDFDocEncod' |egrep 'Warning|label|aux'


# the second BibTeX call resolves cross references,
# this may change the number of pages, but since the indices are not in
# the table of contents, we do not care
kkk-danish.pdf: $(SOURCE)
	pdflatex danish 
	bibtex danish
	pdflatex danish 
	bibtex danish
	correct-toappear
	correct-index
	makeindex -gs index.format -o danish.ind danish.idx
	\rm danish.adx
	authorindex -i -p danish.aux > danish.adx
	sed -e 's/}{/|hyperpage}{/g' danish.adx > danish.adx.hyp
	makeindex -gs index.format -o danish.and danish.adx.hyp
	pdflatex danish 



/Users/stefan/public_html/PS/german-sentence.pdf: german-sentence.pdf
	cp -p $?                      /Users/stefan/public_html/PS/german-sentence.pdf


o-public: /Users/stefan/public_html/PS/german-sentence.pdf 
#	svn commit -m "automatic checkin"
	scp -p $? hpsg.hu-berlin.de:public_html/PS/


code-public: 
	tar cjvf /tmp/german-sentence.tbz *.tex Makefile styles/ Bibliography/ 
	scp -p /tmp/german-sentence.tbz home.hpsg.fu-berlin.de:/home/stefan/public_html/transfer/

clean:
	rm -f *.bak *~ *.log *.blg *.bbl *.aux *.toc *.cut *.out *.tmp *.tpm *.adx *.idx *.ilg *.ind *.and *.glg *.glo *.gls *.657pk *.for *.wdx *.rdx *.ldx *.aux.copy *.lnd *.ldx *.sdx *.snd *.run.xml *.xdv *.mw *.bcf *.adx.hyp

check-clean:
	rm -f *.bak *~ *.log *.blg complex-draft.dvi

realclean: clean
	rm -f *.dvi *.ps *.pdf



