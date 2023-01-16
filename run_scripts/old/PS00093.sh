snakemake \
  -s ../fiberseq-smk/workflow/Snakefile \
  --profile ../fiberseq-smk/profile/compute \
  --notemp \
  --config \
      scatter_threads=4 \
      gmm_model=trained.gmm.model.pkl \
      PS00093=/mmfs1/gscratch/stergachislab/data/PS00092-96_PS00104-107/subread-demultiplex/demux.subreads.bc1003_PS00093--bc1003_PS00093.bam \
      ref=/mmfs1/gscratch/stergachislab/assemblies/hg38.analysisSet.fa \
      env="fiberseq-smk" \
  -p \
  $@

exit 
  --profile profile/checkpoint \
  --profile ../fiberseq-smk/profile/checkpoint \
