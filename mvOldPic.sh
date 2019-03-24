#!/bin/sh


mkdir -p oldpic/

for d in `find . -name '*\.assets' -type d`
do
  md=${d%assets}md
  if [ ! -f "$md" ]; then
    md=$(find . -name "${md##*/}")
    if [ -z "$md" ]; then
      echo "not found: $md"
      break
    fi
  fi
  echo "md is: $md"

  for i in `ls $d/`
  do
    if grep -Fq "$i" $md; then
      continue
    else
      echo $d/$i
      mv $d/$i oldpic/
    fi
  done
done 
