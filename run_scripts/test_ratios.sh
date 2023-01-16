

ls results/b*/un*bam \
  | parallel -n 1 \
  $'echo {} ; ft extract {} --all - | csvtk cut -f total_m6a_bp,total_AT_bp,ec -tT -C "$" | tail -n+2 | awk \'$3>=8 {print 100*$1/$2}\' | textHistogram /dev/stdin; echo'
