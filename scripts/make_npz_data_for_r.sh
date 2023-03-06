set -euo pipefail

mkdir -p npz_r_data/
s=0.01
n=10000
rl=100


cat > temp.tbl <<- EOM
results/PS00075_1/PS00075_1.fiberseq.bam,2.0.npz
../fiberseq-smk/results/ft_PS00075_1/ft_PS00075_1.fiberseq.bam,ft_2.0.npz
results/PS00109_2/PS00109_2.fiberseq.bam,2.2.npz
results/ft_PS00109_1/ft_PS00109_1.fiberseq.bam,ft_2.2.npz
../fiberseq-smk/results/PS00243_subread/PS00243_subread.fiberseq.bam,3.2_fiberseq.npz
validation_data/PS00243-m6A-ML-val-Fiber-seq-bc2017/PS00243_ML.fiberseq.bam,ft_3.2.npz
EOM
touch a.txt 
cat temp.tbl | parallel --colsep ',' -k '/mmfs1/gscratch/stergachislab/mvollger/projects/large_home/software/samtools-1.17/samtools reset -O BAM -@8 {1}  | m6adata --hifi - a.txt --threads 16 --train --min-read-length 100 --min-nuc-length 0 --max-nuc-length 100000 -s 0.01 -n 10000 -o npz_r_data/{2}'


exit 
../fiberseq-smk/results/AoU_subread/AoU_subread.fiberseq.bam,3.2_AoU.npz

exit 

m6adata --hifi \
  results/PS00075_1/PS00075_1.fiberseq.bam \
  --min-nuc-length 0 --max-nuc-length 100000 \
  --threads $(nproc) - -o npz_r_data/2.0.npz --train -s $s --min-read-length $rl -n $n
  #results/PS00075_1/PS00075_1.unaligned.fiberseq.bam \

m6adata --hifi \
  results/PS00109_2/PS00109_2.fiberseq.bam \
  --min-nuc-length 0 --max-nuc-length 100000 \
  --threads $(nproc) - -o npz_r_data/2.2.npz --train -s $s --min-read-length $rl -n $n

m6adata --hifi \
  ../fiberseq-smk/results/ft_PS00075_1/ft_PS00075_1.fiberseq.bam \
  --min-nuc-length 0 --max-nuc-length 100000 \
  --threads $(nproc) - -o npz_r_data/ft_2.2.npz --train -s $s --min-read-length $rl -n $n

m6adata --hifi \
  ../fiberseq-smk/results/PS00243_subread/PS00243_subread.fiberseq.bam \
  --min-nuc-length 0 --max-nuc-length 100000 \
  --threads $(nproc) - -o npz_r_data/3.2_fiberseq.npz --train -s $s --min-read-length $rl -n $n

m6adata --hifi \
  ../fiberseq-smk/results/AoU_subread/AoU_subread.fiberseq.bam \
  --min-nuc-length 0 --max-nuc-length 100000 \
  --threads $(nproc) - -o npz_r_data/3.2_AoU.npz --train -s $s --min-read-length $rl -n $n


exit 

m6adata --hifi \
  validation_data/PS00234-m6A-ML-val-WGA-with-160-uM-m6ATP-bc2008/PS00234_ML.fiberseq.bam \
  --threads $(nproc) - -o npz_r_data/3.2_m6ATP.npz --train \
  -s $s -n $n --min-read-length $rl \
  --min-nuc-length 0 --max-nuc-length 100000 \
  --min-nuc-bp 0 --min-nucs 0

m6adata --hifi \
  from_pb/m84008_230107_003043_s1.SUBSET.hifi_reads.m6a.nuc.low.filter.bam \
  --is_u16 -m 244 \
  --min-nuc-length 0 --max-nuc-length 100000 \
  --threads $(nproc) - -o npz_r_data/Revio.npz --train -s $s --min-read-length $rl -n $n


