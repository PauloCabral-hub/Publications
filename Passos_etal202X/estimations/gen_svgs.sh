#!/bin/bash
# Date 04/03/2024
# Description: This routine are used to generate pdfs from a set of tikz.tex files in
# a folder

NUM_FILES=$( ls -l | grep -i '.tex' | wc -l )

k=1

while [ $k -le $NUM_FILES ]
do
	TO_EVAL1="pdflatex subj_num1_utree${k}.tex && rm *.log *.aux"
	TO_EVAL2="pdf2svg subj_num1_utree${k}.pdf subj_num1_utree${k}.svg"
	TO_EVAL3="svgexport subj_num1_utree${k}.svg subj_num1_utree${k}.png"
	eval $TO_EVAL1
	eval $TO_EVAL2
	eval $TO_EVAL3
        k=`expr $k + 1`
done

eval "rm *.pdf *.svg"
