find . -name _output -exec bash -c 'rsync -avhm --delete "$0/." "vai.univ-tln.fr:public_html/notebooks/$(echo $0|cut -d '/' -f 2)"' {} \;

