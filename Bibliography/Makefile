BIGLATEX=latex
#DVIPS=/opt/tex/bin/dvips
MKINDEX=makeindex -s index.format     # home

# scheint leider nicht zu funktionieren

#MKINDEX=makeindex -gs index.format   # dfki (German Order)

#DVIPS-OPTIONS=-Pcmz

#DVIPS-OPTIONS=-Pstefan



clean:
	find . -name \*\.bak -exec \rm {} \;
	find . -name \*~ -exec \rm {} \;
	rm -f *.bak *.toc *.bbl *.blg *~ *.log *.aux *.*pk
	rm -f subind.* wordind.* langind.* autind*
	rm -f lesen.dvi

tempclean:
	rm -f temp.aux temp.toc

realclean: clean
	rm -f *.dvi *.ps


bib-nice:
	bibtool -r .bibtool100-clean biblio.bib > biblio.bib.new


bib-cooperation:
	bibtool -r .bibtool100-no-comments-no-notes  biblio.bib > biblio.bib.coop


texexec --pdfcombine --comb=2*4 vortrag.pdf

