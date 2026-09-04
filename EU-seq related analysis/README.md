# EU-seq related analysis

`1.pepline_EUseq.sh`: 用于EU-seq的上游分析。

`2.counts.R`: 用于处理EU-seq使用featureCounts获取的counts矩阵。

`3.DEG.R`: 用于分析两组之间的表达差异基因。

`4.DEG-M_APH vs M_DMSO.R`: 利用`3.DEG.R`得到的Rdata，继续分析获取Mitotic APH组比Mitotic DMSO组显著上调或下调的基因。

`5.DEG-M_DMSO vs Asy_DMSO.R`: 利用`3.DEG.R`得到的Rdata，继续分析获取Mitotic DMSO组比非同步化DMSO组显著上调或下调的基因。

`6.prepare for GSEA analysis of EUseq and reported nacent RNAseq.R`: 用于获取GSEA分析所需要的gmt和rnk文件，用于分析EU-seq与前人报道的[nacent RNAseq](http://doi.org/10.1016/j.molcel.2015.09.021)的相关性。
