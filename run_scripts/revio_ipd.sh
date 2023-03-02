snakemake \
  -s ../fiberseq-smk/workflow/Snakefile \
  --profile ../fiberseq-smk/profile/compute \
  --config \
      save_ipd=True ipdsummary=True input_type=subreads \
      Revio_subreads=./from_pb/m84008_230107_003043_s1.subreads.bam \
      ref=/mmfs1/gscratch/stergachislab/assemblies/hg38.analysisSet.fa \
      env="fiberseq-smk" \
  -p \
  $@

exit 
  --profile ../fiberseq-smk/profile/checkpoint \
      process_first_n=300 \
      scatter_threads=4 \
/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210323_225143/m64076_210323_225143.subreads.bam
/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210329_073337/m64076_210329_073337.subreads.bam

