ft=fibertools-rs/target/release/ft
pushd fibertools-rs/
git pull
cargo build --release --features cnn
popd

m=1
if [ $1 == "109" ]; then
  sm="PS00109_1"
elif [ $1 == "GM12878" ]; then
  sm="GM12878"
  m=10
elif [ $1 == "revio" ]; then
  sm="Revio"
  unset FT_REVIO
  export FT_REVIO="true"
  $ft -t $(nproc) predict-m6a -v data/Revio.bam data/$sm.semi.bam -s -a
  $ft -t $(nproc) extract -s -m 240 --all - data/$sm.semi.bam | bgzip -@ $(nproc) > data/$sm.semi.tbl.gz
  exit
else
  sm="PS00075_1"
fi

echo $sm 

if [ $2 == "y"  ]; then 

  zcat results/$sm/ipdSummary/$sm.{1,2,3}-of-736.gff.gz | hck -d, -f 1 | uniq | sort | uniq | rg -v refName | sed 's/"//g' > data/${sm}.reads
  echo "^@" >> data/${sm}.reads
  
  head data/${sm}.reads
  tail data/${sm}.reads


  samtools view -h -@ $(nproc) results/$sm/$sm.fiberseq.bam \
    | rg -f data/${sm}.reads \
    | samtools view -F 2048 -@ $(nproc) -b \
    > data/$sm.gmm.bam 
fi

if [ $2 == "g"  ]; then 
  samtools view -@ 30 -s 0.01 -h  ../fiberseq-smk/results/GM12878_4/GM12878_4_aligned.fiberseq.bam \
    | head -n 10000 \
    | samtools view -b -@ 30 \
  > data/${sm}.gmm.bam 
  exit 
fi

echo "predicting"
unset FT_REVIO

$ft -t $(nproc) extract -s -m $m --all - data/$sm.gmm.bam | bgzip -@ $(nproc) > data/$sm.gmm.tbl.gz

$ft -t $(nproc) predict-m6a -v data/$sm.gmm.bam data/$sm.cnn.bam -c -a
$ft -t $(nproc) extract -s -m $m --all - data/$sm.cnn.bam | bgzip -@ $(nproc) > data/$sm.cnn.tbl.gz

$ft -t $(nproc) predict-m6a -v data/$sm.gmm.bam data/$sm.semi.bam -s -a
$ft -t $(nproc) extract -s -m $m --all - data/$sm.semi.bam | bgzip -@ $(nproc) > data/$sm.semi.tbl.gz

$ft -t $(nproc) predict-m6a -v data/$sm.gmm.bam data/$sm.xgb.bam -a
$ft -t $(nproc) extract -s -m $m --all - data/$sm.xgb.bam | bgzip -@ $(nproc) > data/$sm.xgb.tbl.gz

