snakemake \
  -s ../fiberseq-smk/workflow/Snakefile \
  --profile ../fiberseq-smk/profile/checkpoint \
  --notemp \
  --config \
      process_first_n=20 \
      PS00075_1=/mmfs1/gscratch/stergachislab/data/PS00075/m54329U_210328_013807/m54329U_210328_013807.subreads.bam \
      ref=/mmfs1/gscratch/stergachislab/assemblies/hg38.analysisSet.fa \
      env="fiberseq-smk" \
  -p \
  $@

exit 
  --profile ../fiberseq-smk/profile/compute \
      scatter_threads=4 \
/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210323_225143/m64076_210323_225143.subreads.bam
/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210329_073337/m64076_210329_073337.subreads.bam

