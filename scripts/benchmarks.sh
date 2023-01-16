mkdir -p results_of_benchmark 

# hours
ls benchmarks/ft_PS*_* -d | parallel -n1 $'printf "{/.}\t"; cat {}/predict_m6a_with_fibertools_rs/*tbl | sort -ru | cut -f 1,10 | datamash --header-in sum 1 sum 2 count 1 | awk \'{print $1/3600"\t"$2/3600,"\t"$3}\'' | sort -g > results_of_benchmark/new_hours.txt
ls benchmarks/{PS00075,PS00109}_* -d | parallel -n1 $'printf "{/.}\t"; cat {}/{actc,ipdSummary,gmm}/*tbl | sort -ru | cut -f 1,10 | datamash --header-in sum 1 sum 2 count 1 | awk \'{print $1/3600"\t"$2/3600,"\t"$3}\'' | sort -g > results_of_benchmark/old_hours.txt


# throughput

ls results/ft_PS0*/*tbl.gz | parallel $'printf "{/.}\t"; hck -F total_m6a_bp -z {} | datamash --header-in sum 1 count 1 | awk \'{print $1/1e6"\t"$2/1e6}\'' | sort -g > results_of_benchmark/new_m6a.txt
ls results/{PS00075,PS00109}_{1,2,3}/PS*_{1,2,3}.fiberseq*tbl.gz | parallel $'printf "{/.}\t"; hck -F total_m6a_bp -z {} | datamash --header-in sum 1 count 1 | awk \'{print $1/1e6"\t"$2/1e6}\'' | sort -g > results_of_benchmark/old_m6a.txt

ls results/ft_PS0*/bed/*un*m6a*bed.gz | parallel $'printf "{/.}\t"; zcat {} | wc -l' | sort -g > results_of_benchmark/new_n_reads.txt
ls results/PS0*_{1,2,3}/bed/PS*un*m6a*bed.gz | parallel $'printf "{/.}\t"; zcat {} | wc -l' | sort -g > results_of_benchmark/old_n_reads.txt

exit
# for both
ls results/ft_PS0*/*bam | parallel $'printf "{/.}\t"; samtools view -@ 8 {} -F 2304 -b | ft extract -s --all - | hck -F fiber_length | datamash --header-in sum 1 | awk \'{print $1/1e9}\'' | sort -g > results_of_benchmark/gpb.txt


exit
head results_of_benchmark/*
ls benchmarks/PS*_* -d | parallel -n1 $'printf "{/.}\t"; cat {}/gmm/*tbl | sort -ru | cut -f 1,10 | datamash --header-in sum 1 sum 2 count 1 | awk \'{print $1/3600"\t"$2/3600,"\t"$3}\'' | sort -g 


