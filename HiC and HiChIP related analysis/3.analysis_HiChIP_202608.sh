#分析NCAPH HiChIP loops
cd /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiChIP_APH_Mock
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiChIP_APH_BMH21
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiChIP_DMSO_Mock
~/FitHiChIP/FitHiChIP_HiCPro.sh -C configfile_HiChIP_DMSO_BMH21

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/DMSO_Mock/FitHiChIP_Peak2Peak_b5000_L10000_U2000000/Coverage_Bias/FitHiC_BiasCorr/Merge_Nearby_Interactions/
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' DMSO_Mock.interactions_FitHiC_Q0.8_MergeNearContacts_IGV.bedpe > /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/loop/DMSO_Mock.Peak2Peak.NCAPH_loop.bedpe
cd /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/DMSO_BMH21/FitHiChIP_Peak2Peak_b5000_L10000_U2000000/Coverage_Bias/FitHiC_BiasCorr/Merge_Nearby_Interactions/
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' DMSO_BMH21.interactions_FitHiC_Q0.8_MergeNearContacts_IGV.bedpe > /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/loop/DMSO_BMH21.Peak2Peak.NCAPH_loop.bedpe
cd /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/APH_Mock/FitHiChIP_Peak2Peak_b5000_L10000_U2000000/Coverage_Bias/FitHiC_BiasCorr/Merge_Nearby_Interactions/
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' APH_Mock.interactions_FitHiC_Q0.8_MergeNearContacts_IGV.bedpe > /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/loop/APH_Mock.Peak2Peak.NCAPH_loop.bedpe
cd /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/APH_BMH21/FitHiChIP_Peak2Peak_b5000_L10000_U2000000/Coverage_Bias/FitHiC_BiasCorr/Merge_Nearby_Interactions/
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' APH_BMH21.interactions_FitHiC_Q0.8_MergeNearContacts_IGV.bedpe > /mnt/NC/LJW/HiChIP_NCAPH_202608/FitHiChIP/loop/APH_BMH21.Peak2Peak.NCAPH_loop.bedpe

#hic转cool/h5
cd /mnt/NC/LJW/HiChIP_NCAPH_202608/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 100000
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/cool/
cool2=*_100000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/h5/
h5=*_100000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _100000.h5 $id)_100000.OE.h5 
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 50000
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/cool/
cool2=*_50000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/h5/
h5=*_50000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _50000.h5 $id)_50000.OE.h5 
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 5000
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/cool/
cool2=*_5000.cool
ls $cool2 | while read id
do
hicConvertFormat -m ${id} --inputFormat cool \
--outputFormat h5 -o ../h5/$(basename -s .cool $id).h5
done

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/h5/
h5=*_5000.h5
ls $h5 | while read id
do
hicTransform -m ${id} --method obs_exp_lieberman -o $(basename -s _5000.h5 $id)_5000.OE.h5 
done

cd /mnt/NC/LJW/Hic_202607/cool/
hicConvertFormat -m DMSO_BMH21_5000.cool --inputFormat cool \
--outputFormat h5 -o ../h5/DMSO_BMH21_5000.h5
hicConvertFormat -m DMSO_Mock_5000.cool --inputFormat cool \
--outputFormat h5 -o ../h5/DMSO_Mock_5000.h5
cd /mnt/NC/LJW/Hic_202607/h5/
hicTransform -m DMSO_BMH21_5000.h5 --method obs_exp_lieberman -o DMSO_BMH21_5000.OE.h5 
hicTransform -m DMSO_Mock_5000.h5 --method obs_exp_lieberman -o DMSO_Mock_5000.OE.h5 
hicConvertFormat -m DMSO_BMH21_5000.OE.h5  --inputFormat h5 \
--outputFormat cool -o ../cool/DMSO_BMH21_5000.OE.cool
hicConvertFormat -m DMSO_Mock_5000.OE.h5  --inputFormat h5 \
--outputFormat cool -o ../cool/DMSO_Mock_5000.OE.cool

cd /mnt/NC/LJW/Hic_202607/cool/
hicConvertFormat -m DMSO_BMH21_25000.cool --inputFormat cool \
--outputFormat h5 -o ../h5/DMSO_BMH21_25000.h5
hicConvertFormat -m DMSO_Mock_25000.cool --inputFormat cool \
--outputFormat h5 -o ../h5/DMSO_Mock_25000.h5
cd /mnt/NC/LJW/Hic_202607/h5/
hicTransform -m DMSO_BMH21_25000.h5 --method obs_exp_lieberman -o DMSO_BMH21_25000.OE.h5 
hicTransform -m DMSO_Mock_25000.h5 --method obs_exp_lieberman -o DMSO_Mock_25000.OE.h5 
hicConvertFormat -m DMSO_BMH21_25000.OE.h5  --inputFormat h5 \
--outputFormat cool -o ../cool/DMSO_BMH21_25000.OE.cool
hicConvertFormat -m DMSO_Mock_25000.OE.h5  --inputFormat h5 \
--outputFormat cool -o ../cool/DMSO_Mock_25000.OE.cool

cd /mnt/NC/LJW/Hic_202607/h5/
hicConvertFormat -m APH_BMH21_25000.OE.h5 --inputFormat h5 \
--outputFormat cool -o ../cool/APH_BMH21_25000.OE.cool
hicConvertFormat -m APH_Mock_25000.OE.h5 --inputFormat h5 \
--outputFormat cool -o ../cool/APH_Mock_25000.OE.cool

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/hic/
hic=*.hic
ls $hic | while read id
do
hicConvertFormat -m ${id} --inputFormat hic \
--outputFormat cool -o ../cool/$(basename -s .hic $id).cool --resolutions 25000
done

#作图
cd /mnt/NC/LJW/HiChIP_NCAPH_202608/figure/
hicPlotTADs --tracks tracks.ini.table --width 9 --height 9 --region chr8:20,250,000-23,750,000 -o HiChIP_loops.chr8.pdf 
hicPlotTADs --tracks tracks.ini2.table --width 9 --height 9 --region chr1:36,000,000-39,000,000 -o HiChIP_loops.chr1.pdf 

cd /mnt/NC/LJW/HiChIP_NCAPH_202608/figure/
hicPlotTADs --tracks tracks.ini3.table --width 9 --height 9 --region chr3:37,500,000-41,250,000 -o APH_HiChIP_loops.chr3.pdf 
hicPlotTADs --tracks tracks.ini4.table --width 9 --height 9 --region chr7:69,000,000-72,500,000 -o APH_HiChIP_loops.chr7.pdf 
