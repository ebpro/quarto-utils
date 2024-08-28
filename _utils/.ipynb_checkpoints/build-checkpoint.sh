#!/bin/bash
source /opt/conda/bin/activate base
quarto render $@ --execute

quarto render $@ --profile slides 
