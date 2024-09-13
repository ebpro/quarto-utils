#!/bin/bash

# mv _output/_slides/* _output/
#for l in $(find . -name *_L-slides_*.ipynb -and -not -name "*-checkpoint.ipynb");
#do
#	unlink $l
#done

find . -name "*.slides-speaker.html" -not -path "./_output/*" -exec mv {} _output/{} \;

