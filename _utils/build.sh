#!/bin/bash

#jupyter kernelspec list 
#echo
#python -m nb_conda_kernels list
#echo 
#jupyter kernelspec list 

git config --global --add safe.directory /home/jovyan/work/local

# quarto render $@ --no-cache --execute --profile notes
quarto render $@ --profile notes 
# --to html
quarto render $(echo $@|sed 's/--execute//'|sed 's/--no-cache//') --profile slides 
#--to revealjs 
