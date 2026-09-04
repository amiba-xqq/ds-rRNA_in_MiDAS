rm(list = ls())  
options(stringsAsFactors = F)
library(DESeq2)
library("BiocParallel") #启用多核计算
load(file = '1.counts.Rdata')
##设定 实验组exp / 对照组ctr
ctr="M_DMSO"
exp="M_APH"

##构建dds DESeqDataSet
if(T){
  dds <- DESeqDataSetFromMatrix(countData = counts_filt,
                                colData = gl,
                                design = ~ group_list)
}

dds$group_list <- relevel(dds$group_list, ref = ctr)   #指定 control group

keep <- rowSums(counts(dds)) >= 1.5*ncol(counts)  #Pre-filtering ，过滤低表达基因
dds <- dds[keep,] 
dds <- DESeq(dds,quiet = F) 
res <- results(dds,contrast=c("group_list", exp, ctr))  #指定提取为exp/ctr结果
resOrdered <- res[order(res$padj),]  #order根据padj从小到大排序结果
tempDEG <- as.data.frame(resOrdered)
DEG_DEseq2 <- na.omit(tempDEG)
DEG_DEseq2$geneid <- rownames(DEG_DEseq2)
DEG_M_APHvsDMSO <- DEG_DEseq2
save(DEG_M_APHvsDMSO,file = "DEG_M_APHvsDMSO.Rdata")

##设定 实验组exp / 对照组ctr
ctr="Asy_DMSO"
exp="M_DMSO"

##构建dds DESeqDataSet
if(T){
  dds <- DESeqDataSetFromMatrix(countData = counts_filt,
                                colData = gl,
                                design = ~ group_list)
}

dds$group_list <- relevel(dds$group_list, ref = ctr)   #指定 control group

keep <- rowSums(counts(dds)) >= 1.5*ncol(counts)  #Pre-filtering ，过滤低表达基因
dds <- dds[keep,] 
dds <- DESeq(dds,quiet = F) 
res <- results(dds,contrast=c("group_list", exp, ctr))  #指定提取为exp/ctr结果
resOrdered <- res[order(res$padj),]  #order根据padj从小到大排序结果
tempDEG <- as.data.frame(resOrdered)
DEG_DEseq2 <- na.omit(tempDEG)
DEG_DEseq2$geneid <- rownames(DEG_DEseq2)
DEG_M_DMSOvsAsy_DMSO <- DEG_DEseq2
save(DEG_M_DMSOvsAsy_DMSO,file = "DEG_M_DMSOvsAsy_DMSO.Rdata")

##设定 实验组exp / 对照组ctr
ctr="noEU"
exp="M_DMSO"

##构建dds DESeqDataSet
if(T){
  dds <- DESeqDataSetFromMatrix(countData = counts_filt,
                                colData = gl,
                                design = ~ group_list)
}

dds$group_list <- relevel(dds$group_list, ref = ctr)   #指定 control group

keep <- rowSums(counts(dds)) >= 1.5*ncol(counts)  #Pre-filtering ，过滤低表达基因
dds <- dds[keep,] 
dds <- DESeq(dds,quiet = F) 
res <- results(dds,contrast=c("group_list", exp, ctr))  #指定提取为exp/ctr结果
resOrdered <- res[order(res$padj),]  #order根据padj从小到大排序结果
tempDEG <- as.data.frame(resOrdered)
DEG_DEseq2 <- na.omit(tempDEG)
DEG_DEseq2$geneid <- rownames(DEG_DEseq2)
DEG_M_DMSOvsnoEU <- DEG_DEseq2
save(DEG_M_DMSOvsnoEU,file = "DEG_M_DMSOvsnoEU.Rdata")

##设定 实验组exp / 对照组ctr
ctr="noEU"
exp="M_APH"

##构建dds DESeqDataSet
if(T){
  dds <- DESeqDataSetFromMatrix(countData = counts_filt,
                                colData = gl,
                                design = ~ group_list)
}

dds$group_list <- relevel(dds$group_list, ref = ctr)   #指定 control group

keep <- rowSums(counts(dds)) >= 1.5*ncol(counts)  #Pre-filtering ，过滤低表达基因
dds <- dds[keep,] 
dds <- DESeq(dds,quiet = F) 
res <- results(dds,contrast=c("group_list", exp, ctr))  #指定提取为exp/ctr结果
resOrdered <- res[order(res$padj),]  #order根据padj从小到大排序结果
tempDEG <- as.data.frame(resOrdered)
DEG_DEseq2 <- na.omit(tempDEG)
DEG_DEseq2$geneid <- rownames(DEG_DEseq2)
DEG_M_APHvsnoEU <- DEG_DEseq2
save(DEG_M_APHvsnoEU,file = "DEG_M_APHvsnoEU.Rdata")

##设定 实验组exp / 对照组ctr
ctr="noEU"
exp="Asy_DMSO"

##构建dds DESeqDataSet
if(T){
  dds <- DESeqDataSetFromMatrix(countData = counts_filt,
                                colData = gl,
                                design = ~ group_list)
}

dds$group_list <- relevel(dds$group_list, ref = ctr)   #指定 control group

keep <- rowSums(counts(dds)) >= 1.5*ncol(counts)  #Pre-filtering ，过滤低表达基因
dds <- dds[keep,] 
dds <- DESeq(dds,quiet = F) 
res <- results(dds,contrast=c("group_list", exp, ctr))  #指定提取为exp/ctr结果
resOrdered <- res[order(res$padj),]  #order根据padj从小到大排序结果
tempDEG <- as.data.frame(resOrdered)
DEG_DEseq2 <- na.omit(tempDEG)
DEG_DEseq2$geneid <- rownames(DEG_DEseq2)
DEG_Asy_DMSOvsnoEU <- DEG_DEseq2
save(DEG_Asy_DMSOvsnoEU,file = "DEG_Asy_DMSOvsnoEU.Rdata")




















