#下面两行路径根据实际情况更改，dir是分析的最上级文件夹路径，gtf是GTF文件所在路径,gemome是基因组比对的索引文件的所在路径
dir=/mnt/LJW/EUseq202503
gtf=/home/DDR/GTF/Homo_sapiens.GRCh38.112.gtf
genome=/home/DDR/genome/hisat2_GRCh38/hisat2_GRCh38
#创建各个文件夹存放RNA-seq各步骤产生文件
cd ${dir};
mkdir cleandata bam bam_sort counts;

#针对raw reads进行质检
cd ${dir}/raw/;
mkdir raw_trimed;
ls *.gz | xargs fastqc -t 6 -o ./raw_trimed;
multiqc ./raw_trimed -n multiraw -o ./multiqcresults_raw/;

#清洗reads
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
   --qualified_quality_phred 15 \
   --low_complexity_filter \
   --complexity_threshold 30 \
   --length_required 4 \
   --thread 4
done

#对clean reads做质检
cd ${dir}/cleandata/;
mkdir clean_trimed;
ls *.gz | xargs fastqc -t 6 -o ./clean_trimed;
multiqc ./clean_trimed -n multiclean -o ./multiqcresults_clean/;

#reads比对基因组，得到bam文件
cd ${dir}/cleandata/;
mv *.txt ./multiqcresults_clean;
mv *.json ./multiqcresults_clean;
mv *.html ./multiqcresults_clean;
ls *_1*  >1
ls *_2*  >2
paste 1 2 >config
cat config | while read id
do
    arr=($id)
    fq1=${arr[0]}
    fq2=${arr[1]}
    hisat2 -p 20 --dta-cufflinks --un-conc -x ${genome} -1 $fq1 -2 $fq2 | samtools view -Sb > ${dir}/bam/$(basename -s _1.fq.gz $fq1).bam;
done

#对bam文件进行排序
cd ${dir}/bam/;
files=*.bam
ls $files | while read id
do
 samtools sort -@ 20 -O bam -o ${dir}/bam_sort/$(basename -s .bam $id)sorted.bam  ${id}
done

#bam文件添加索引
cd ${dir}/bam_sort/;
ls *.bam | xargs  -i  samtools index {};

#计算bam文件比对率
cd ${dir}/bam_sort/;
file_bamsort=*bam
ls $file_bamsort | while read id
do
samtools flagstat $id > $(basename -s .bam $id).stat
done
#得到counts矩阵
gtf=/home/Liaojunwei/Homo_sapiens.GRCh38.112.+chr.gtf
featureCounts -M -s 2 --read2pos 5 -T 8 -p -a ${gtf} -o ../counts/counts_RNAseq.txt  *.bam

#转化成bw文件
dir=/mnt/LJW/EUseq202503
cd ${dir}/bam_sort/
sample=*.bam
ls $sample | while read id
do
echo $id
bamCoverage -p 18 --normalizeUsing CPM -b $id -o ${dir}/bw/$(basename -s .bam $id).bw
done 

dir=/mnt/LJW/EUseq202503
cd ${dir}/bam_sort/;
file_bamsort=*bam
ls $file_bamsort | while read id
do
samtools sort -n -@ 20 -O bam -o ${dir}/bam_sort_by_name/$(basename -s .bam $id)name.bam ${id}
done

cd ${dir}/bam_sort_by_name/;
dir=/mnt/LJW/EUseq202503
gtf=/home/Liaojunwei/Homo_sapiens.GRCh38.112.+chr.gtf
featureCounts -M -s 2 -t gene --read2pos 5 -T 8 -p -a ${gtf} -o ../counts/counts_RNAseq.txt  *.bam

#拆分bam的正负链信息
dir=/mnt/LJW/EUseq202503
cd ${dir}/bam_sort/;
file2=*bam
ls $file_bamsort | while read id
do
samtools view -b -f 128 -F 16 ${id} > ../tmp/$(basename -s .bam $id).fwd1.bam
samtools view -b -f 80 ${id} > ../tmp/$(basename -s .bam $id).fwd2.bam
samtools merge -f ../bam_sort_strand/$(basename -s .bam $id).fwd.bam ../tmp/$(basename -s .bam $id).fwd1.bam ../tmp/$(basename -s .bam $id).fwd2.bam
samtools view -b -f 144 ${id} > ../tmp/$(basename -s .bam $id).rev1.bam
samtools view -b -f 64 -F 16 ${id} > ../tmp/$(basename -s .bam $id).rev2.bam
samtools merge -f ../bam_sort_strand/$(basename -s .bam $id).rev.bam ../tmp/$(basename -s .bam $id).rev1.bam ../tmp/$(basename -s .bam $id).rev2.bam
done
cd ${dir}/bam_sort_strand/;
dir=/mnt/LJW/EUseq202503
ls *.bam | xargs  -i  samtools index {};
file3=*bam
ls $sample | while read id
do
echo $id
bamCoverage -p 18 --normalizeUsing CPM -b $id -o ${dir}/bw_strand/$(basename -s .bam $id).bw
done 

#作图
cd /mnt/LJW/EUseq202503/figures/
hicPlotTADs --tracks tracks.ini.table --width 11 --height 10 --region chr21:8,432,836-8,447,836 -o rRNA.pdf 
