

snakemake \
  -s ../fiberseq-smk/workflow/Snakefile \
  --profile ../fiberseq-smk/profile/compute \
  --set-scatter chunks=20 \
  --notemp \
  --config \
      scatter_threads=4 \
      gmm_model=trained.gmm.model.pkl \
      bc1008=/mmfs1/gscratch/stergachislab/data/PS00092-96_PS00104-107/demultiplex_subreads/bc1008.m54329U_210920_190616.subreads.bam \
      bc1009=/mmfs1/gscratch/stergachislab/data/PS00092-96_PS00104-107/demultiplex_subreads/bc1009.m54329U_210920_190616.subreads.bam \
      bc1010=/mmfs1/gscratch/stergachislab/data/PS00092-96_PS00104-107/demultiplex_subreads/bc1010.m54329U_210920_190616.subreads.bam \
      bc1011=/mmfs1/gscratch/stergachislab/data/PS00092-96_PS00104-107/demultiplex_subreads/bc1011.m54329U_210920_190616.subreads.bam \
      bc1012=/mmfs1/gscratch/stergachislab/data/PS00092-96_PS00104-107/demultiplex_subreads/bc1012.m54329U_210920_190616.subreads.bam \
      bc1015=/mmfs1/gscratch/stergachislab/data/PS00092-96_PS00104-107/demultiplex_subreads/bc1015.m54329U_210920_190616.subreads.bam \
      ref=/mmfs1/gscratch/stergachislab/assemblies/hg38.analysisSet.fa \
      env="fiberseq-smk" \
  -p \
  $@


exit 
  --profile profile/checkpoint \
  --profile ../fiberseq-smk/profile/checkpoint \
