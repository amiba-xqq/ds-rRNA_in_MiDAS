#cnvkit使用pip install cnvkit下载，即可使用cnvkit.py
cd /mnt/LJW/WGRS_202606/
cnvkit.py access /home/DDR/genome/bwa_hg38/hg38.fa -s 5000 -o ./cnn/access-5kb.hg38.bed
cd /mnt/LJW/WGRS_202606/bam/
cnvkit.py autobin DMSO-Mock.bam -g ../cnn/access-5kb.hg38.bed \
--annotate /home/DDR/genome/bwa_hg38/refFlat.txt --short-names -m wgs
cnvkit.py coverage DMSO-Mock.bam DMSO-Mock.target.bed -p 12 -o ../cnn/DMSO-Mock.targetcoverage.cnn
cnvkit.py reference ../cnn/DMSO-Mock.targetcoverage.cnn --fasta /home/DDR/genome/bwa_hg38/hg38.fa -o ../cnn/reference.cnn

cd /mnt/LJW/WGRS_202606/bam/
bam=*.bam
ls $bam| while read id
do
cnvkit.py batch ${id} -r ../cnn/reference.cnn -d ../cnn/results/ -p 20 -m wgs
done

cd /mnt/LJW/WGRS_202606/cnn/results/
cnr=*.cnr
ls $cnr| while read id
do
cnvkit.py export seg $(basename -s .cnr $id).cns -o $(basename -s .cnr $id).seg
done

cd /mnt/LJW/WGRS_202606/cnn/results/
cnr=*.cnr
ls $cnr| while read id
do
cnvkit.py heatmap $(basename -s .cnr $id).cns -d -x Female -o $(basename -s .cnr $id).heatmap.pdf
cnvkit.py scatter ${id} -s $(basename -s .cnr $id).cns -o $(basename -s .cnr $id).scatter.pdf
cnvkit.py diagram ${id} -s $(basename -s .cnr $id).cns -o $(basename -s .cnr $id).diagram.pdf -x Female --no-gene-labels
done
