#!/bin/bash

COMMAND=`basename $0`
Usage()
{
cat << EOF
make clean
make cleantag
EOF
}


################################################################################
# Argument processing
################################################################################
argnum=0
pass=0

while getopts :r opt
do
  case $opt in
    r)  CLEAN=1;   argnum=`expr $argnum + 1` ;;
    *)  Usage $*; exit 1 ;;
  esac
done

shift $argnum

DIR=$*

echo $DIR

################################################################################
# Main
################################################################################

if [ ! -z $CLEAN ]; then
  echo 'find $* -type d -a ! \( -name \.git -prune \) -exec sh -c "cd \"{}\"; rm -f tags" \;'
  find $* -type d -a ! \( -name \.git -prune \) -exec sh -c "cd \"{}\"; rm -f tags" \;
else 
  echo 'find $* -type d -a ! \( -type d -empty \) -a ! \( -name \.git -prune \) -exec sh -c "cd \"{}\"; if test ! -f .keep; then ctags --extra=+q --fields=+ani --C++-kinds=+p *; fi" \;'
  find $* -type d -a ! \( -type d -empty \) -a ! \( -name \.git -prune \) -exec sh -c "cd \"{}\"; if test ! -f .keep; then ctags --extra=+q --fields=+ani --C++-kinds=+p *; fi" \;
  echo "(cd $*; ctags --file-scope=no -R)"
  (cd $*; ctags --file-scope=no -R)
fi

