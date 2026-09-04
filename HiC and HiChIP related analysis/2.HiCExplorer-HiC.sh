#hic转化为cool和h5
cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 5000
done

cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 10000
done

cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 50000
done

cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 25000
done

cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 100000
done

cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 250000
done

cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 500000
done

cd /mnt/NC/LJW/Hic_202607/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 1000000
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool2=*_10000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool2=*_50000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool2=*_25000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool2=*_100000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool2=*_1000000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool2=*_500000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

# hicTransform
cd /mnt/NC/LJW/Hic_202607/cool/
cool=*_50000.cool
ls $cool | while read id
do
hicNormalize -m ${id} -n norm_range -o $(basename -s _50000.cool $id)_50000.nor.cool
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool2=*_50000.nor.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_50000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _50000.h5 $id)_50000.OE.h5 
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_25000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _25000.h5 $id)_25000.OE.h5 
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_10000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _10000.h5 $id)_10000.OE.h5 
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_250000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _250000.h5 $id)_250000.OE.h5 
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_100000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _100000.h5 $id)_100000.OE.h5 
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_1000000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _1000000.h5 $id)_1000000.OE.h5 
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_1000000.h5
ls $h5 | while read id
do
hicNormalize -m ${id} -n norm_range -o $(basename -s _1000000.h5 $id)_1000000.nor.h5
done

cd /mnt/NC/LJW/Hic_202607/h5/
h5=*_500000.h5
ls $h5 | while read id
do
hicNormalize -m ${id} -n norm_range -o $(basename -s _500000.h5 $id)_500000.nor.h5
done

#寻找各组的TAD
cd /mnt/NC/LJW/Hic_202607/cool/
cool=*_5000.cool
ls $cool | while read id
do
hicNormalize -m ${id} -n norm_range -o $(basename -s .cool $id).nor.cool
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool=*_10000.cool
ls $cool | while read id
do
hicNormalize -m ${id} -n norm_range -o $(basename -s .cool $id).nor.cool
done
cool2=*_10000.nor.cool
ls $cool2 | while read id
do
hicCorrectMatrix correct --matrix ${id} --correctionMethod KR --outFileName $(basename -s .nor.cool $id).KR.cool
done

cool3=*_10000.KR.cool
ls $cool3 | while read id
do
hicFindTADs -m ${id} \
--outPrefix ../TAD/$(basename -s _10000.KR.cool $id) \
--minDepth 30000 \
--maxDepth 100000 \
--step 10000 \
--thresholdComparisons 0.1 \
--delta 0.01 \
--correctForMultipleTesting fdr \
-p 15
done

#hicPlotMatrix作图
cd /mnt/NC/LJW/Hic_202607/cool/
cool=*_250000.cool
ls $cool | while read id
do
hicNormalize -m ${id} -n norm_range -o $(basename -s _250000.cool $id)_250000.nor.cool
done

cd /mnt/NC/LJW/Hic_202607/cool/
cool=*_250000.cool
ls $cool | while read id
do
hicCorrectMatrix correct -m ${id} --correctionMethod ICE -o $(basename -s _250000.cool $id)_250000.coverage.cool --iterNum 1
done

cd /mnt/NC/LJW/Hic_202607/h5/
hicCompareMatrices -m APH_Mock_100000.OE.h5 APH_BMH21_100000.OE.h5 \
--operation log2ratio -o APHMock_vs_APHBMH21.h5

cd /mnt/NC/LJW/Hic_202607/h5/
hicCompareMatrices -m DMSO_Mock_100000.OE.h5 DMSO_BMH21_100000.OE.h5 \
--operation log2ratio -o DMSOMock_vs_DMSOBMH21.h5

cd /mnt/NC/LJW/Hic_202607/h5/
hicPlotMatrix -m APHMock_vs_APHBMH21.h5 \
--outFileName ../figure/APHMock_vs_APHBMH21.chr1.pdf -t 'APHMock_vs_APHBMH21' \
--colorMap RdBu_r --region chr1:15,000,000-35,000,000 \
--increaseFigureHeight 1.5  \
--vMax 3 --vMin -3

cd /mnt/NC/LJW/Hic_202607/h5/
hicPlotMatrix -m DMSOMock_vs_DMSOBMH21.h5 \
--outFileName ../figure/DMSOMock_vs_DMSOBMH21.chr1.pdf -t 'DMSOMock_vs_DMSOBMH21' \
--colorMap RdBu_r --region chr1:15,000,000-35,000,000 \
--increaseFigureHeight 1.5  \
--vMax 3 --vMin -3

#FitHiChIP分析
cd /mnt/NC/LJW/Hic_202607/FitHiChIP/
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiC_APH_Mock
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiC_APH_BMH21
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiC_DMSO_Mock
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiC_DMSO_BMH21

#计算diff_loops
cd /mnt/NC/LJW/Hic_202607/FitHiChIP/diff_loops/
awk 'NR>1 && $1 != "chrY" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' DMSO_Mock.interactions_FitHiC_Q0.2.bed > DMSO_Mock.HiC.bedpe
awk 'NR>1 && $1 != "chrY" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' DMSO_BMH21.interactions_FitHiC_Q0.2.bed > DMSO_BMH21.HiC.bedpe
cat DMSO_Mock.HiC.bedpe DMSO_BMH21.HiC.bedpe | sort -k1,1 -k2,2n -k4,4 -k5,5n -u | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' > DMSO_total.HiC.bedpe
#DMSO_Mock.pairs.gz共265830889 pairs;DMSO_BMH21.pairs.gz共281704048 pairs
cd /mnt/NC/LJW/Hic_202607/FitHiChIP/diff_loops/
python calculate_Hic_counts_in_loops.py /mnt/NC/LJW/Hic_202607/bam/DMSO-Mock.pairs.gz DMSO_total.HiC.bedpe DMSO_Mock.table
python calculate_Hic_counts_in_loops.py /mnt/NC/LJW/Hic_202607/bam/DMSO-BMH21.pairs.gz DMSO_total.HiC.bedpe DMSO_BMH21.table

paste DMSO_BMH21.table <(cut -f7 DMSO_Mock.table) > tmp
awk 'BEGIN{OFS="\t"} !($7<5 && $8<5) { 
    ratio = (($7+1)*265830889)/(($8+1)*281704048);
    log2val = (ratio>0 ? log(ratio)/log(2) : "NA");
    print $0, log2val
}' tmp > DMSO.table
rm tmp
awk '$9> (log(1.5)/log(2)) {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' DMSO.table > DMSOBMH21_vs_DMSOMock_up.Hic_loop.bedpe
awk '$9< -(log(1.5)/log(2)) {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' DMSO.table > DMSOBMH21_vs_DMSOMock_down.Hic_loop.bedpe

cd /mnt/NC/LJW/Hic_202607/APA/HiChIP/
fanc aggregate /mnt/NC/LJW/HiChIP_NCAPH_202608/cool/DMSO_BMH21_50000.cool \
DMSOBMH21_vs_DMSOMock_down.Hic_loop.bedpe DMSO_BMH21_NCAPH_HiChIP_in_down_HiC_loops.agg \
-p DMSO_BMH21_NCAPH_HiChIP_in_down_HiC_loops.pdf \
-m DMSO_BMH21_NCAPH_HiChIP_in_down_HiC_loops.txt \
-e -l --colormap RdBu_r --vmax 4 --vmin -4

cd /mnt/NC/LJW/Hic_202607/APA/HiChIP/
fanc aggregate /mnt/NC/LJW/HiChIP_NCAPH_202608/cool/DMSO_Mock_50000.cool \
DMSOBMH21_vs_DMSOMock_down.Hic_loop.bedpe DMSO_Mock_NCAPH_HiChIP_in_down_HiC_loops.agg \
-p DMSO_Mock_NCAPH_HiChIP_in_down_HiC_loops.pdf \
-m DMSO_Mock_NCAPH_HiChIP_in_down_HiC_loops.txt \
-e -l --colormap RdBu_r --vmax 4 --vmin -4

cd /mnt/NC/LJW/Hic_202607/APA/HiChIP/
fanc aggregate /mnt/NC/LJW/Hic_202607/cool/DMSO_BMH21_50000.cool \
DMSOBMH21_vs_DMSOMock_down.Hic_loop.bedpe DMSO_BMH21_HiC_in_down_HiC_loops.agg \
-p DMSO_BMH21_HiC_in_down_HiC_loops.pdf \
-m DMSO_BMH21_HiC_in_down_HiC_loops.txt \
-e -l --colormap RdBu_r --vmax 4 --vmin -4

cd /mnt/NC/LJW/Hic_202607/APA/HiChIP/
fanc aggregate /mnt/NC/LJW/Hic_202607/cool/DMSO_Mock_50000.cool \
DMSOBMH21_vs_DMSOMock_down.Hic_loop.bedpe DMSO_Mock_HiC_in_down_HiC_loops.agg \
-p DMSO_Mock_HiC_in_down_HiC_loops.pdf \
-m DMSO_Mock_HiC_in_down_HiC_loops.txt \
-e -l --colormap RdBu_r --vmax 4 --vmin -4

# 分析得到各组hic的insulation score的bw文件
cd /mnt/NC/LJW/Hic_202607/insulation/
fanc insulation ../cool/APH_Mock_5000.cool APH_Mock.insulation -w 50000 -o bed 
fanc insulation ../cool/APH_BMH21_5000.cool APH_BMH21.insulation -w 50000 -o bed 
fanc insulation ../cool/DMSO_Mock_5000.cool DMSO_Mock.insulation -w 50000 -o bed 
fanc insulation ../cool/DMSO_BMH21_5000.cool DMSO_BMH21.insulation -w 50000 -o bed 

awk '$5!="nan" && $5!="-inf" {print $1"\t"$2"\t"$3"\t"$5}' APH_Mock.insulation_50kb.bed > tmp1
sort -k1,1 -k2,2n tmp1 > tmp2
bedGraphToBigWig tmp2 ../hg38.mainonly.chrom.size APH_Mock.insulation_50kb.bw
awk '$5!="nan" && $5!="-inf" {print $1"\t"$2"\t"$3"\t"$5}' APH_BMH21.insulation_50kb.bed > tmp1
sort -k1,1 -k2,2n tmp1 > tmp2
bedGraphToBigWig tmp2 ../hg38.mainonly.chrom.size APH_BMH21.insulation_50kb.bw
awk '$5!="nan" && $5!="-inf" {print $1"\t"$2"\t"$3"\t"$5}' DMSO_Mock.insulation_50kb.bed > tmp1
sort -k1,1 -k2,2n tmp1 > tmp2
bedGraphToBigWig tmp2 ../hg38.mainonly.chrom.size DMSO_Mock.insulation_50kb.bw
awk '$5!="nan" && $5!="-inf" {print $1"\t"$2"\t"$3"\t"$5}' DMSO_BMH21.insulation_50kb.bed > tmp1
sort -k1,1 -k2,2n tmp1 > tmp2
bedGraphToBigWig tmp2 ../hg38.mainonly.chrom.size DMSO_BMH21.insulation_50kb.bw
rm tmp*

#分析APH各组在TAD边界的insulation
cd /mnt/NC/LJW/Hic_202607/insulation/
computeMatrix reference-point -S APH_Mock.insulation_50kb.bw APH_BMH21.insulation_50kb.bw \
-R /mnt/NC/LJW/Hic_202607/TAD/APH_Mock_boundaries.bed \
-p 20 -a 500000 -b 500000 -bs 1000 --referencePoint center --skipZeros --missingDataAsZero --averageTypeBins mean \
-o ../deeptools/APH_group_insulation_in_TAD_boundaries.gz \
--outFileSortedRegions ../deeptools/APH_group_insulation_in_TAD_boundaries.bed
plotProfile -m ../deeptools/APH_group_insulation_in_TAD_boundaries.gz \
-out ../deeptools/APH_group_insulation_in_TAD_boundaries.Profile.pdf \
--plotFileFormat pdf --perGroup --dpi 720  --samplesLabel APH_Mock APH_BMH21 \
--plotHeight 6 --plotWidth 8  --refPointLabel "TAD boundaries" --yAxisLabel CPM
plotHeatmap -m ../deeptools/APH_group_insulation_in_TAD_boundaries.gz  \
-out ../deeptools/APH_group_insulation_in_TAD_boundaries.Heatmap.pdf \
--plotFileFormat pdf  --dpi 720 --colorMap RdBu_r --samplesLabel APH_Mock APH_BMH21 --yAxisLabel CPM \
--heatmapHeight 15 --heatmapWidth 4 --refPointLabel "TAD boundaries"

#分析DMSO各组在TAD边界的insulation
cd /mnt/NC/LJW/Hic_202607/insulation/
computeMatrix reference-point -S DMSO_Mock.insulation_50kb.bw DMSO_BMH21.insulation_50kb.bw \
-R /mnt/NC/LJW/Hic_202607/TAD/DMSO_Mock_boundaries.bed \
-p 20 -a 500000 -b 500000 -bs 1000 --referencePoint center --skipZeros --missingDataAsZero --averageTypeBins mean \
-o ../deeptools/DMSO_group_insulation_in_TAD_boundaries.gz \
--outFileSortedRegions ../deeptools/DMSO_group_insulation_in_TAD_boundaries.bed
plotProfile -m ../deeptools/DMSO_group_insulation_in_TAD_boundaries.gz \
-out ../deeptools/DMSO_group_insulation_in_TAD_boundaries.Profile.pdf \
--plotFileFormat pdf --perGroup --dpi 720  --samplesLabel DMSO_Mock DMSO_BMH21 \
--plotHeight 6 --plotWidth 8  --refPointLabel "TAD boundaries" --yAxisLabel CPM
plotHeatmap -m ../deeptools/DMSO_group_insulation_in_TAD_boundaries.gz  \
-out ../deeptools/DMSO_group_insulation_in_TAD_boundaries.Heatmap.pdf \
--plotFileFormat pdf  --dpi 720 --colorMap RdBu_r --samplesLabel DMSO_Mock DMSO_BMH21 --yAxisLabel CPM \
--heatmapHeight 15 --heatmapWidth 4 --refPointLabel "TAD boundaries"


