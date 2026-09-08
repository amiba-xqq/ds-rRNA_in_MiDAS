####分析G2_DMSO/DMSO_Mock/APH_Mock三组的peak，并合并,并分析各组在peak附近的分布，并分群####
cd /mnt/LJW/ATACseq_202505/bam_merge/
macs2 callpeak -t G2_DMSO.merged.bam -n G2_DMSO -f BAM -g hs --outdir ../peaks/ -q 0.05 --keep-dup all --nomodel
macs2 callpeak -t DMSO_Mock.merged.bam -n DMSO_Mock -f BAM -g hs --outdir ../peaks/ -q 0.05 --keep-dup all --nomodel
macs2 callpeak -t APH_Mock.merged.bam -n APH_Mock -f BAM -g hs --outdir ../peaks/ -q 0.05 --keep-dup all --nomodel
macs2 callpeak -t APH_BMH21.merged.bam -n APH_BMH21 -f BAM -g hs --outdir ../peaks/ -q 0.05 --keep-dup all --nomodel
macs2 callpeak -t G2_APH.merged.bam -n G2_APH -f BAM -g hs --outdir ../peaks/ -q 0.05 --keep-dup all --nomodel
cd /mnt/LJW/ATACseq_202505/peaks/
awk '{print $1"\t"$2"\t"$3}' G2_DMSO_peaks.narrowPeak > tmp1
awk '{print $1"\t"$2"\t"$3}' DMSO_Mock_peaks.narrowPeak > tmp2
awk '{print $1"\t"$2"\t"$3}' APH_Mock_peaks.narrowPeak > tmp3
cat tmp1 tmp2 tmp3 > tmp4
sort -k1,1V -k2,2n -k3,3n tmp4 > tmp5
bedtools merge -i tmp5 > G2_and_M_total.bed
rm tmp*

#分析各组分布
cd /mnt/LJW/ATACseq_202505/bw/
computeMatrix reference-point -S G2_DMSO.merged.bw G2_APH.merged.bw DMSO_Mock.merged.bw DMSO_BMH21.merged.bw APH_Mock.merged.bw APH_BMH21.merged.bw \
-R /mnt/LJW/ATACseq_202505/peaks/G2_and_M_total.bed \
-p 15 -a 5000 -b 5000 --referencePoint center --skipZeros --missingDataAsZero --averageTypeBins mean \
-o ../deeptools/G2_and_M_total.gz \
--outFileSortedRegions ../deeptools/G2_and_M_total.bed
plotProfile -m ../deeptools/G2_and_M_total.gz \
-out ../deeptools/G2_and_M_total.Profile.pdf \
--plotFileFormat pdf --perGroup --dpi 720  --samplesLabel G2_DMSO G2_APH M_DMSO M_BMH21 M_APH M_APH_BMH21 \
--plotHeight 6 --plotWidth 8  --refPointLabel 'total peaks' --yAxisLabel CPM
plotHeatmap -m ../deeptools/G2_and_M_total.gz  \
-out ../deeptools/G2_and_M_total.Heatmap.pdf \
--plotFileFormat pdf  --dpi 720 --colorMap Greens --samplesLabel G2_DMSO G2_APH M_DMSO M_BMH21 M_APH M_APH_BMH21 \
--heatmapHeight 15 --heatmapWidth 4 --refPointLabel 'total peaks' \
--kmeans 5 \
--outFileSortedRegions ../deeptools/G2_and_M_total.2.bed

cd ../deeptools/
awk '($1 !~ /^#/ ) && (($13 == "cluster_5") || ($13 == "cluster_4")) {print}' G2_and_M_total.2.bed > G2_and_M_total.3.bed

cd /mnt/LJW/ATACseq_202505/bw/
computeMatrix reference-point -S G2_DMSO.merged.bw DMSO_Mock.merged.bw APH_Mock.merged.bw \
-R ../deeptools/G2_and_M_total.3.bed \
-p 20 -a 5000 -b 5000 --referencePoint center --skipZeros --missingDataAsZero --averageTypeBins mean \
-o ../deeptools/G2_and_M_total.gz \
--outFileSortedRegions ../deeptools/G2_and_M_total.bed
plotProfile -m ../deeptools/G2_and_M_total.gz \
-out ../deeptools/G2_and_M_total.Profile.pdf \
--plotFileFormat pdf --perGroup --dpi 720  --samplesLabel G2_DMSO M_DMSO M_APH \
--plotHeight 6 --plotWidth 8  --refPointLabel 'total peaks' --yAxisLabel CPM
plotHeatmap -m ../deeptools/G2_and_M_total.gz  \
-out ../deeptools/G2_and_M_total.Heatmap.pdf \
--plotFileFormat pdf  --dpi 720 --colorMap Greens --samplesLabel G2_DMSO M_DMSO M_APH \
--heatmapHeight 15 --heatmapWidth 4 --refPointLabel 'total peaks'
