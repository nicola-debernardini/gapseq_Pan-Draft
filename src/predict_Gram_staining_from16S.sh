#!/bin/bash

fasta=$1
name="${fasta%.*}"

path=$(readlink -f "$0")
dir=$(dirname "$path")

blastn -db $dir/../dat/seq/Bacteria/16S_graminfo/16S_gramposinfo.fna -query $fasta -outfmt 6 -qcov_hsp_perc 95 -perc_identity 80 | sort -k12,12nr -k3,3nr | head -11 | awk '$1{print $2}' | grep -Po '=(.*)' > $name.grpred.tmp

posc=`grep -c pos $name.grpred.tmp`
negc=`grep -c neg $name.grpred.tmp`

res=""
if [[ $posc > $negc ]]; then
  res="pos"
elif [[ $posc < $negc ]]; then
  res="neg"
elif [[ $posc = $negc ]]; then
  res="ambiguous"
fi

rm $name.grpred.tmp

echo $res