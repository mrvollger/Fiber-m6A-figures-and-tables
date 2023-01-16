
bam=results/PS00092/mini.actc.2.bam
fa=ipdSummary/ccs.fasta

mkdir -p ipdSummary 
mkdir -p ipdSummary/csv
mkdir -p ipdSummary/gff

#cat temp/PS00092/actc.1{1,2,3,4,5,6,7,8,9}-of-983.fasta > $fa
#samtools faidx $fa

idx=1

for idx in 1 2 3 4 5 6 7 8 9; do
  echo $idx 

  id=1${idx}-of-983
  fa=temp/PS00092/actc.$id.fasta
  bam=temp/PS00092/actc.$id.bam
  csv=ipdSummary/csv/ipd.$id.csv
  gff=ipdSummary/gff/ipd.$id.gff

  ipdSummary \
      --reference $fa \
      --pvalue 0.01 \
      --numWorkers $(nproc) \
      --quiet --identify m6A \
      --csv $csv \
      --gff $gff \
      $bam 

done 
