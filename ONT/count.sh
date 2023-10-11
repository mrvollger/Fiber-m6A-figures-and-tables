

ls H*bam | parallel --gnu -j 8 'echo {}; ft extract -m 1 {} --all - | hck -F total_m6a_bp -F total_AT_bp  | datamash -H sum 1 sum 2; echo'
ls H*bam | parallel --gnu -j 8 'echo {}; ft extract -m 1 {} --all - | bgzip > {.}.tbl.gz'
