#!/bin/bash
#下面两行路径根据实际情况更改，dir是分析的最上级文件夹路径,gemome是基因组比对的索引文件的所在路径
dir=/mnt/LJW/ATACseq_202505
genome=/home/DDR/genome/hisat2_GRCh38/hisat2_GRCh38
#创建各个文件夹存放ChIP-seq各步骤产生文件
cd ${dir}/
mkdir cleandata bam bam_sort bw bam_rmdup peaks bam_merge

#针对raw reads进行质检
cd  ${dir}/raw/
mkdir fastq_results
ls *.gz | xargs fastqc -t 12 -o  ./fastq_results/
multiqc ./fastq_results/ -n multiqc_raw -o ./multiqcresults/

#清洗reads,只针对pair-end reads
cd ${dir}/raw/
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
    --qualified_quality_phred 20 \
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
mv *.txt ./multiqcresults
mv *.json ./multiqcresults
mv *.html ./multiqcresults

#reads比对基因组，得到bam文件,只针对pair-end reads
ls *_1*  >1
ls *_2*  >2
paste 1 2 >config
cat config | while read id
do
    arr=($id)
    fq1=${arr[0]}
    fq2=${arr[1]}
    hisat2 -p 18 --dta-cufflinks --un-conc -x ${genome} -1 $fq1 -2 $fq2 | samtools view -Sb > ${dir}/bam/$(basename -s _1.fq.gz $fq1).bam
done

#去除重复的reads
cd ${dir}/bam/
files_bam=*.bam
ls $files_bam | while read id 
do
echo $id
sambamba markdup -r -t 18 $id ${dir}/bam_rmdup/$(basename -s .bam $id).rmdup.bam
done

#对bam文件进行排序
cd ${dir}/bam_rmdup/
files=*.bam
ls $files | while read id
do
 samtools sort -@ 18 -O bam -o ${dir}/bam_sort/$(basename -s .bam $id)sorted.bam  ${id}
done

#bam文件添加索引
cd ${dir}/bam_sort/
ls *.bam | xargs  -i  samtools index {}
#计算bam文件比对率
cd ${dir}/bam_sort/
file_bamsort=*bam
ls $file_bamsort | while read id
do
samtools flagstat $id > $(basename -s .bam $id).stat
done

#导出bigwig文件，可用于可视化已经下游分析
cd ${dir}/bam_sort/
sample=*.bam
ls $sample | while read id
do
echo $id
bamCoverage -p 18 --normalizeUsing CPM -b $id -o ${dir}/bw/$(basename -s .bam $id).bw
done 

cd /mnt/LJW/ATACseq_202505/bam_sort/
samtools merge -o ../bam_merge/APH_BMH21.merged.bam APH_BMH21rep1.rmdupsorted.bam APH_BMH21rep2.rmdupsorted.bam
samtools merge -o ../bam_merge/APH_Mock.merged.bam APH_Mockrep1.rmdupsorted.bam APH_Mockrep2.rmdupsorted.bam
samtools merge -o ../bam_merge/DMSO_BMH21.merged.bam DMSO_BMH21rep1.rmdupsorted.bam DMSO_BMH21rep2.rmdupsorted.bam
samtools merge -o ../bam_merge/DMSO_Mock.merged.bam DMSO_Mockrep1.rmdupsorted.bam DMSO_Mockrep2.rmdupsorted.bam
samtools merge -o ../bam_merge/G2_APH.merged.bam G2_APHrep1.rmdupsorted.bam G2_APHrep2.rmdupsorted.bam
samtools merge -o ../bam_merge/G2_DMSO.merged.bam G2_DMSOrep1.rmdupsorted.bam G2_DMSOrep2.rmdupsorted.bam

cd ../bam_merge/
ls *.bam | xargs  -i  samtools index {}
file_bamsort2=*bam
ls $file_bamsort2 | while read id
do
samtools flagstat $id > $(basename -s .bam $id).stat
bamCoverage -p 18 --normalizeUsing CPM -b $id -o ../bw/$(basename -s .bam $id).bw
done
