snakemake \
  -s ../fiberseq-smk/workflow/Snakefile \
  --profile ../fiberseq-smk/profile/checkpoint \
  --config \
      save_ipd=True ipdsummary=True input_type=subreads \
      PS00075_1=/mmfs1/gscratch/stergachislab/data/PS00075/m54329U_210328_013807/m54329U_210328_013807.subreads.bam \
      PS00075_2=/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210323_225143/m64076_210323_225143.subreads.bam \
      PS00075_3=/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210329_073337/m64076_210329_073337.subreads.bam \
      PS00109_1=/mmfs1/gscratch/stergachislab/data/PS00109.AS/m54329U_220113_034357.subreads.bam \
      PS00109_2=/mmfs1/gscratch/stergachislab/data/PS00109.AS/m54329U_220120_125531.subreads.bam \
      PS00109_3=/mmfs1/gscratch/stergachislab/data/PS00109.AS/m54329U_220121_235228.subreads.bam \
      ref=/mmfs1/gscratch/stergachislab/assemblies/hg38.analysisSet.fa \
      env="fiberseq-smk" \
  -p \
  $@

exit 
      process_first_n=300 \
  --profile ../fiberseq-smk/profile/compute \
      scatter_threads=4 \
/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210323_225143/m64076_210323_225143.subreads.bam
/mmfs1/gscratch/stergachislab/data/PS00075/m64076_210329_073337/m64076_210329_073337.subreads.bam

