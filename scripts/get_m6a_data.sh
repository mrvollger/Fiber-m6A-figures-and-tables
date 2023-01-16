m6adata --hifi results/PS00075_2/unaligned.fiberseq.bam - -o data/PS00075_2_2022-10-17.npz  -s 0.01 --train
m6adata --hifi results/PS00075_1_larger/unaligned.fiberseq.bam - -o data/PS00075_1_2022-10-17.npz  -s 0.03 --train

ft -t 30 -v predict-m6a results/PS00075_2/unaligned.fiberseq.bam xgb.bam 
ft -t 30 -v predict-m6a results/PS00075_2/unaligned.fiberseq.bam cnn.bam -c

ft -t 30 -v predict-m6a results/PS00075_1/unaligned.fiberseq.bam xgb.bam 
ft -t 30 -v predict-m6a results/PS00075_1/unaligned.fiberseq.bam cnn.bam -c

ft -t 30 extract -m 1 --all - xgb.bam | bgzip -@ 30 > xgb.tbl.gz
ft -t 30 extract -m 1 --all - cnn.bam | bgzip -@ 30 > cnn.tbl.gz



exit 
m6adata -s 0.1 -t $(nproc) -k results/PS00075_1/mini.actc.bam results/PS00075_1/unaligned.fiberseq.tbl.gz -o results/PS00075_1/MoreReadsLargeSMRTmatrix.pkl
m6adata -s 0.01 -t $(nproc) -k results/PS00075_1/mini.actc.bam results/PS00075_1/unaligned.fiberseq.tbl.gz -o results/PS00075_1/MoreReadsSMRTmatrix.pkl

scp results/PS00075_1/MoreReads*SMRTmatrix.pkl web:/data/www/phweb01.s.uw.edu/public/mvollger/.

m6aMLdata results/PS00075_1/MoreReadsLargeSMRTmatrix.pkl --save-path-prefix ml_data/PS00075_1_Large_


m6adata --buffer 1 -t $(nproc) -k results/PS00075_1/mini.actc.2.bam results/PS00075_1/unaligned.fiberseq.tbl.gz -o results/PS00075_1/PredictAll.pkl

m6adata --buffer 1 -t $(nproc) -k results/PS00075_1/mini.actc.2.bam <(zcat results/PS00075_1/unaligned.fiberseq.tbl.gz | head -n 14500) -o results/PS00075_1/PredictAll.pkl
m6aMLdata results/PS00075_1/PredictAll.pkl --save-path-prefix ml_data/PS00075_1_PredictAll_

m6adata --buffer 1 -t $(nproc) -k results/PS00093/mini.actc.bam <( zcat results/PS00093/unaligned.fiberseq.tbl.gz | head -n 3000) -o results/PS00093/PredictAll.pkl
m6aMLdata results/PS00093/PredictAll.pkl --save-path-prefix ml_data/PS00083_PredictAll_

exit 

ft -t 32 extract --all - results/PS00075_1/unaligned.fiberseq.bam | bgzip -@ 32 > results/PS00075_1/unaligned.fiberseq.tbl.gz

samtools merge -o - temp/PS00075_1/actc.{1,2,3,4,5,6,7,8,9}-of-*.bam  -f -@ 30  | samtools sort -m8G -@16 -o results/PS00075_1/mini.actc.bam --write-index 
samtools merge -o - temp/PS00075_1/actc.1{1,2,3,4,5,6,7,8,9}-of-*.bam  -f -@ 30  | samtools sort -m8G -@16 -o results/PS00075_1/mini.actc.2.bam --write-index 


