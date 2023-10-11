
hck -z -F fiber data/PS00109_1.semi.tbl.gz > tmp.reads.txt
rg -z -f tmp.reads.txt -l ipdSummary/PS00109_1*
rg -j 8 -z -f tmp.reads.txt ipdSummary/PS00109_1* -I | rg kinModCall | rg m6A | sort -k1,1 -k4,4n | bgzip > data/PS00109_1.ipd.tbl.gz


