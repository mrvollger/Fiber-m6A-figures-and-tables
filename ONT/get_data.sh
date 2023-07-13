 n=15000

 samtools view -h ../../phased-fdr-and-peaks/altius/HG002_ONT_m6a_Eichler/temp_bam/HG002_2.tmp.bam | head -n $n | samtools view -b > HG002_2.bam 
 samtools view -h ../../phased-fdr-and-peaks/altius/HG002_ONT_m6a_Eichler/temp_bam/HG002_3.tmp.bam | head -n $n | samtools view -b > HG002_3.bam 

 ls H*bam | parallel "samtools index -@ 16 {}"
