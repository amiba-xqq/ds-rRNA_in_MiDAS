rm(list = ls())
library(tidyverse)
library(readxl)
####获取MiDAS-regions的基因信息####
# Macheret M, Bhowmick R, Sobkowiak K, et al. High-resolution mapping of mitotic DNA synthesis regions and common fragile sites in the human genome through direct sequencing. Cell Res. 2020;30(11):997-1008. doi:10.1038/s41422-020-0358-x
MiDAS <- read_xls("../MiDAS_regions.xls")
MiDAS <- MiDAS[-(1:5),-1]
a <- as.character(MiDAS[1,])
colnames(MiDAS) <- a
colnames(MiDAS)[17] <- "Gene"
MiDAS <- MiDAS[-1,]
rm(a)

MiDAS.genes <- MiDAS %>%
  filter(str_detect(Gene, "^(ONE_GENE|TWO_GENES)")) %>%  # 筛选相关行
  pull(Gene) %>%                                          # 提取 Gene 列为字符向量
  str_extract_all("(?<=:)[^;]+(?=;)") %>%                # 提取所有 : 与 ; 之间的基因名
  unlist() %>%                                           # 展开为单一向量
  unique() 

#####读取GDSC数据库的input和TPM矩阵#####
total <- read.csv("/mnt/NC/LJW/MiDAS_score/input/GDSC_input_data.2.0.csv",row.names = 1)
tpm <- read.csv("/mnt/NC/LJW/MiDAS_score/raw/rnaseq_merged_rsem_tpm_20260323.csv")
tpm <- tpm[-(1:3),-(2:3)]
colnames(tpm)[1] <- "SYMBOL"
# a <- tpm$cell_id
# tpm <- tpm[,-1]
# rownames(tpm) <- a

tpm.midas <- tpm[tpm$SYMBOL %in% MiDAS.genes,]
table(duplicated(tpm.midas$SYMBOL))
rownames(tpm.midas) <- tpm.midas$SYMBOL
tpm.midas <- tpm.midas[,colnames(tpm.midas) %in% total$SANGER_MODEL_ID]
tpm.midas <- as.data.frame(t(tpm.midas))
tpm.midas$cell_id <- rownames(tpm.midas)
tpm.midas <- tpm.midas[,c(247,1:246)]

write.csv(tpm.midas,"/mnt/NC/LJW/MiDAS_score/input/GDSC_TPM_input_data.csv")


