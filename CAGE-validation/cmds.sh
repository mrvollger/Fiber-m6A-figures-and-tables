set -euo pipefail

mkdir -p temp

if [ "x" == "y" ]; then 
  ls ../results/P*75_{1,2,3}/*.aligned.fiberseq.bam ../results/ft*P*75_{1,2,3}/*.fiberseq.bam \
    | parallel -n 1 \
    $'samtools view -@ 8 -e \'length(seq)>5000\' -ML CAGE.gencode.v42.annotation_TSS.gff3 {} -o temp/{/}'
fi

samtools merge -o sr.bam --write-index temp/P*bam -f -@ 16
samtools merge -o ft.bam --write-index temp/ft*bam -f -@ 16 

ls sr.bam ft.bam | parallel 'ft center -d 2000 -r -t $(nproc) {} CAGE.gencode.v42.annotation_TSS.gff3 | hck -E subset_sequence | bgzip -@ 16 > {.}.tbl.gz'

exit


