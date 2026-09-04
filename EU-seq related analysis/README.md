# EU-seq related analysis

`1.pepline_EUseq.sh`: 用于EU-seq的上游分析。

`2.counts.R`: 用于处理EU-seq使用featureCounts获取的counts矩阵。

`3.DEG.R`: 用于分析两组之间的表达差异基因。

`4.DEG-M_APH vs M_DMSO.R`: 利用`3.DEG.R`得到的Rdata，继续分析获取Mitotic APH组比Mitotic DMSO组显著上调或下调的基因。

`5.DEG-M_DMSO vs Asy_DMSO.R`: 利用`3.DEG.R`得到的Rdata，继续分析获取Mitotic DMSO组比非同步化DMSO组显著上调或下调的基因。

`6.prepare for GSEA analysis of EUseq and reported nacent RNAseq.R`: 用于获取GSEA分析所需要的gmt和rnk文件，用于分析EU-seq与前人报道的[nacent RNAseq](http://doi.org/10.1016/j.molcel.2015.09.021)的相关性。

`DEG_MvsAsy_nacentRNAseq.Rdata`: 用于`6.prepare for GSEA analysis of EUseq and reported nacent RNAseq.R`, [nacent RNAseq](http://doi.org/10.1016/j.molcel.2015.09.021)分析后获取的差异表达基因信息。

`EUseq_M_DMSOvsAsy_DMSO_down.gmt`,`EUseq_M_DMSOvsAsy_DMSO_up.gmt`,`nacent_RNAseq_MvsAsy.rnk`: `6.prepare for GSEA analysis of EUseq and reported nacent RNAseq.R`最后获取的文件，用于GSEA分析。

`counts_RNAseq.txt`: EU-seq上游分析得到的表达矩阵，用于`2.counts.R`。

`g2s_vm25_gencode.txt`: ENSEMBLE ID和SYMBOL的转化文件，用于`2.counts.R`。

`tracks.ini.table`: `1.pepline_EUseq.sh`中用于hicPlotTADs作图的track参数文件。

===========================================================================================

`1.pepline_EUseq.sh`: Used for upstream analysis of EU-seq.

`2.counts.R`: Used to process the count matrix obtained from EU-seq using featureCounts.

`3.DEG.R`: Used to analyze differentially expressed genes between two groups.

`4.DEG-M_APH vs M_DMSO.R`: Using the Rdata obtained from `3.DEG.R`, further analyze to obtain genes significantly upregulated or downregulated in the Mitotic APH group compared to the Mitotic DMSO group.

`5.DEG-M_DMSO vs Asy_DMSO.R`: Using the Rdata obtained from `3.DEG.R`, further analyze to obtain genes significantly upregulated or downregulated in the Mitotic DMSO group compared to the asynchronous DMSO group.

`6.prepare for GSEA analysis of EUseq and reported nacent RNAseq.R`: Used to obtain the gmt and rnk files required for GSEA analysis, to analyze the correlation between EU-seq and previously reported [nacent RNAseq](http://doi.org/10.1016/j.molcel.2015.09.021).

`DEG_MvsAsy_nacentRNAseq.Rdata`: Used in `6.prepare for GSEA analysis of EUseq and reported nacent RNAseq.R`, differential expression gene information obtained after analysis of [nacent RNAseq](http://doi.org/10.1016/j.molcel.2015.09.021).

`EUseq_M_DMSOvsAsy_DMSO_down.gmt`,`EUseq_M_DMSOvsAsy_DMSO_up.gmt`,`nacent_RNAseq_MvsAsy.rnk`: Files finally obtained from `6.prepare for GSEA analysis of EUseq and reported nacent RNAseq.R`, used for GSEA analysis.

`counts_RNAseq.txt`: The expression matrix obtained from the upstream analysis of EU-seq, used in `2.counts.R`.

`g2s_vm25_gencode.txt`: Conversion file between ENSEMBLE ID and SYMBOL, used in `2.counts.R`.

`tracks.ini.table`: Track parameter file used for hicPlotTADs plotting in `1.pepline_EUseq.sh`.
