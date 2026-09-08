dir=/mnt/LJW/J2_RIPseq_202511
genome=/home/DDR/genome/hisat2_GRCh38/hisat2_GRCh38
cd ${dir}/
mkdir cleandata bam bam_sort bw peaks

cd /mnt/LJW/J2_RIPseq_202511/raw_part/
zcat IgG-IP_L1_1.fq.gz IgG-IP_L2_1.fq.gz | gzip -1 > ../raw/IgG-IP_1.fq.gz
zcat IgG-IP_L1_2.fq.gz IgG-IP_L2_2.fq.gz | gzip -1 > ../raw/IgG-IP_2.fq.gz

cd  ${dir}/raw/
mkdir fastq_results;
ls *.gz | xargs fastqc -t 12 -o  ./fastq_results/;
multiqc ./fastq_results/ -n multiqc_raw -o ./multiqcresults/;

ls *_1*  >1
ls *_2*  >2
paste 1 2 >config
cat config | while read id
do
    arr=($id)
    fq1=${arr[0]}
    fq2=${arr[1]}
    time fastp \
    --in1 $fq1 \
    --in2 $fq2 \
    --out1 ../cleandata/$(basename -s .fq.gz $fq1).fq.gz \
    --out2 ../cleandata/$(basename -s .fq.gz $fq2).fq.gz \
    --json ../cleandata/$(basename -s _1.fq.gz $fq1).json \
    --html ../cleandata/$(basename -s _1.fq.gz $fq1).html \
    --trim_poly_g --poly_g_min_len 6 \
    --trim_poly_x --poly_x_min_len 6 \
    --cut_front --cut_tail --cut_window_size 4 \
    --qualified_quality_phred 25 \
    --low_complexity_filter \
    --complexity_threshold 30 \
    --length_required 4 \
    --thread 4
done

#对clean reads做质检
cd ${dir}/cleandata/
mkdir trimed
ls *.gz | xargs fastqc -t 18 -o ./trimed
multiqc ./trimed -n multi -o ./multiqcresults/
mv *.txt ./multiqcresults/
mv *.json ./multiqcresults/
mv *.html ./multiqcresults/

ls *_1*  >1
ls *_2*  >2
paste 1 2 >config
cat config | while read id
do
    arr=($id)
    fq1=${arr[0]}
    fq2=${arr[1]}
    hisat2 -p 15 --dta-cufflinks --un-conc --sensitive -x ${genome} -1 $fq1 -2 $fq2 | samtools view -Sb > ${dir}/bam/$(basename -s _1.fq.gz $fq1).bam
done

cd ${dir}/bam/;
files=*.bam
ls $files | while read id
do
 samtools sort -@ 15 -O bam -o ${dir}/bam_sort/$(basename -s .bamAligned.out.bam $id)sorted.bam  ${id}
done

cd ${dir}/bam_sort/
ls *.bam | xargs  -i  samtools index {};
file_bamsort3=*bam
ls $file_bamsort3 | while read id
do
	samtools flagstat $id > $(basename -s .bam $id).stat
	bamCoverage -p 15 --normalizeUsing CPM -b $id -o ${dir}/bw/$(basename -s .bam $id).bw
done

#合并重复组
cd /mnt/LJW/J2_RIPseq_202511/bam_sort/
samtools merge -o ../bam_merge/APH-Mock-IP.merged.bam APH-Mock-rep1-IP.bamsorted.bam APH-Mock-rep2-IP.bamsorted.bam
samtools merge -o ../bam_merge/APH-Mock-Un.merged.bam APH-Mock-rep1-Un.bamsorted.bam APH-Mock-rep2-Un.bamsorted.bam
samtools merge -o ../bam_merge/DMSO-Mock-IP.merged.bam DMSO-Mock-rep1-IP.bamsorted.bam DMSO-Mock-rep2-IP.bamsorted.bam
samtools merge -o ../bam_merge/DMSO-Mock-Un.merged.bam DMSO-Mock-rep1-Un.bamsorted.bam DMSO-Mock-rep2-Un.bamsorted.bam
cd /mnt/LJW/J2_RIPseq_202511/bam_merge/ 
ls *.bam | xargs  -i  samtools index {};
bam_merge=*bam
ls $bam_merge | while read id
do
	samtools flagstat $id > $(basename -s .bam $id).stat
	bamCoverage -p 18 --normalizeUsing CPM -b $id -o ../bw_merge/$(basename -s .bam $id).bw
done

#分开minus/plus-strand
cd /mnt/LJW/J2_RIPseq_202511/
mkdir bam_fwd bam_rev bam_strand bw_strand
cd /mnt/LJW/J2_RIPseq_202511/bam_merge/
files=*.bam
ls $files | while read id
do
	samtools view -b -f 128 -F 16 ${id} > ../bam_fwd/$(basename -s .merged.bam $id).fwd1.bam
	samtools view -b -f 80 ${id} > ../bam_fwd/$(basename -s .merged.bam $id).fwd2.bam
	samtools view -b -f 144 ${id} > ../bam_rev/$(basename -s .merged.bam $id).rev1.bam
	samtools view -b -f 64 -F 16 ${id} > ../bam_rev/$(basename -s .merged.bam $id).rev2.bam
done

cd /mnt/LJW/J2_RIPseq_202511/bam_fwd/
ls *fwd1*  >1
ls *fwd2*  >2
paste 1 2 >config
cat config | while read id
do
    arr=($id)
    bam1=${arr[0]}
    bam2=${arr[1]}
	samtools merge -o ../bam_strand/$(basename -s .fwd1.bam $bam1).fwd.bam $bam1 $bam2
done

cd /mnt/LJW/J2_RIPseq_202511/bam_rev/
ls *rev1*  >1
ls *rev2*  >2
paste 1 2 >config
cat config | while read id
do
    arr=($id)
    bam1=${arr[0]}
    bam2=${arr[1]}
	samtools merge -o ../bam_strand/$(basename -s .rev1.bam $bam1).rev.bam $bam1 $bam2
done

cd /mnt/LJW/J2_RIPseq_202511/bam_strand/
ls *.bam | xargs  -i  samtools index {};
file_bamsort3=*bam
ls $file_bamsort3 | while read id
do
	samtools flagstat $id > $(basename -s .bam $id).stat
	bamCoverage -p 18 --normalizeUsing CPM -b $id -o ../bw_strand/$(basename -s .bam $id).bw
done
