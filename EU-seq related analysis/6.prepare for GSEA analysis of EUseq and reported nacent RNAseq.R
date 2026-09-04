rm(list=ls())
library(tidyverse)
load("DEG_MvsAsy_nacentRNAseq.Rdata")
EUseq_upgene <- read.csv('./DEG_M_DMSO_vs_Asy_DMSO_up/DEG_M_DMSO_vs_Asy_DMSO_up_gene.csv',
                         row.names=1)
EUseq_downgene <- read.csv('./DEG_M_DMSO_vs_Asy_DMSO_up/DEG_M_DMSO_vs_Asy_DMSO_down_gene.csv',
                           row.names=1)
####导出EUseq M_DMSO vs Asy_DMSO上调gene的gmt文件####
up.gmx <- as.data.frame(EUseq_upgene$geneid)
colnames(up.gmx) <- "SYMBOL"
up.gmx <- rbind(data.frame(SYMBOL = "EUseq_M_DMSOvsAsy_DMSO_up"), up.gmx)
up.gmx <- rbind(data.frame(SYMBOL = "EUseq_M_DMSOvsAsy_DMSO_up"), up.gmx)
up.gmt <- t(up.gmx)
write.table(up.gmt,"EUseq_M_DMSOvsAsy_DMSO_up.gmt",
            sep="\t",col.names = F,row.names = F,quote = F)

####导出EUseq M_DMSO vs Asy_DMSO下调gene的gmt文件####
down.gmx <- as.data.frame(EUseq_downgene$geneid)
colnames(down.gmx) <- "SYMBOL"
down.gmx <- rbind(data.frame(SYMBOL = "EUseq_M_DMSOvsAsy_DMSO_down"), down.gmx)
down.gmx <- rbind(data.frame(SYMBOL = "EUseq_M_DMSOvsAsy_DMSO_down"), down.gmx)
down.gmt <- t(down.gmx)
write.table(down.gmt,"EUseq_M_DMSOvsAsy_DMSO_down.gmt",
            sep="\t",col.names = F,row.names = F,quote = F)

####得到nacent RNAseq的rnk文件####
DEG_nacentRNAseq <- DEG_nacentRNAseq[order(DEG_nacentRNAseq$log2FoldChange,decreasing = T),]

nacent_RNAseq <- data.frame(rownames(DEG_nacentRNAseq),
                            DEG_nacentRNAseq$log2FoldChange)
write.table(nacent_RNAseq,"nacent_RNAseq_MvsAsy.rnk",
            sep="\t",col.names = F,row.names = F,quote = F)
