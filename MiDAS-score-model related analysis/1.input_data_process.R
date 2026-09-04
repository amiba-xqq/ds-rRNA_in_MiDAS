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

####获取CFS的长基因信息####
#Wilson TE, Arlt MF, Park SH, et al. Large transcription units unify copy number variants and common fragile sites arising under replication stress. Genome Res. 2015
CFS <- read_xlsx("../human_CFS.xlsx")
colnames(CFS) <- CFS[1,]
CFS <- CFS[-1,]
colnames(CFS)[9] <- "gene"

CFS.genes <- strsplit(CFS[!is.na(CFS$gene),]$gene, split = ",")
CFS.genes <- unlist(CFS.genes)

MiDAS.CFS.genes <- intersect(MiDAS.genes,CFS.genes)

####读取数据-WGS.CNV####
cnv.wgs <- read.csv("../WGS_purple_genes_total_copy_number_20260804.csv")
cnv.wgs <- cnv.wgs[-(2:3),-2]
a <- as.character(cnv.wgs[1,])
a[1] <- "SYMBOL"
colnames(cnv.wgs) <- a
cnv.wgs <- cnv.wgs[-1,]
cnv.wgs <- cnv.wgs %>%
  rowwise() %>%                        
  mutate(na_count = sum(is.na(c_across(-1)))) %>%  
  ungroup() %>%
  group_by(across(1)) %>%               
  slice_min(na_count, n = 1, with_ties = FALSE) %>% 
  select(-na_count)  
table(!duplicated(cnv.wgs$SYMBOL))

####读取数据-WES.CNV####
cnv.wes <- read.csv("../WES_pureCN_CNV_genes_total_copy_number_20250207.csv")
cnv.wes <- cnv.wes[-(2:3),]
a <- as.character(cnv.wes[1,])
a[1] <- "SYMBOL"
colnames(cnv.wes) <- a
cnv.wes <- cnv.wes[-1,]
table(!duplicated(cnv.wes$SYMBOL))
rm(a)

####读取数据-GDSC####
gdsc1 <- read_xlsx("../GDSC1_fitted_dose_response_27Oct23.xlsx")
k <- gdsc1[!duplicated(gdsc1$DRUG_NAME),]$DRUG_NAME
k1 <- gdsc1[!duplicated(gdsc1$DRUG_NAME),]

gdsc2 <- read_xlsx("../GDSC2_fitted_dose_response_27Oct23.xlsx")
k <- gdsc2[!duplicated(gdsc2$DRUG_NAME),]$DRUG_NAME
k2 <- gdsc2[!duplicated(gdsc2$DRUG_NAME),]
# write.table(k,"gdsc2_drug.table",quote = F, col.names = F, row.names = F)

RS.drug2 <- c("Niraparib","5-Fluorouracil","Oxaliplatin","Epirubicin","VE821","Camptothecin",
              "MK-8776","Irinotecan","Teniposide","AZD6738","Topotecan","VE-822",
              "Methotrexate","SN-38","Olaparib","Cyclophosphamide",
              "Talazoparib","Veliparib","AZD7762","Wee1 Inhibitor","Rucaparib",
              "Temozolomide","AZ20","Cisplatin","Etoposide")

length(RS.drug2) #一共25诱导复制压力的药物

gdsc1.rs <- gdsc1[gdsc1$DRUG_NAME %in% RS.drug2,c("SANGER_MODEL_ID","DRUG_NAME","Z_SCORE")]
gdsc2.rs <- gdsc2[gdsc2$DRUG_NAME %in% RS.drug2,c("SANGER_MODEL_ID","DRUG_NAME","Z_SCORE")]

gdsc <- rbind(gdsc1.rs,gdsc2.rs)
gdsc <- gdsc %>%
  group_by(SANGER_MODEL_ID) %>%                  
  summarise(Z_SCORE = mean(Z_SCORE, na.rm = TRUE)) %>%  #对于每种细胞，取药物的Z-score且取均值
  ungroup()
rm(k,k1,k2)
colnames(gdsc)[2] <- "DRUG_Z_score"

####提取各个细胞的MiDAS基因的CNV信息####
#有GDSC药物信息的细胞只做过WES，没有做过WGS
# a <- colnames(cnv.wes)[-1]
# b <- colnames(cnv.wgs)[-1]
# length(intersect(gdsc$SANGER_MODEL_ID,a))
# length(intersect(gdsc$SANGER_MODEL_ID,b))
# rm(a,b)

cnv.wes.midas <- cnv.wes[cnv.wes$SYMBOL %in% MiDAS.genes,]
cnv.wes.midas[is.na(cnv.wes.midas)] <- 2.0
cnv.wes.midas <- as.data.frame(t(cnv.wes.midas))
a <- as.character(cnv.wes.midas[1,])
colnames(cnv.wes.midas) <- paste0(a,"_CNV")
cnv.wes.midas <- cnv.wes.midas[-1,]
cnv.wes.midas$SANGER_MODEL_ID <- rownames(cnv.wes.midas)
cnv.wes.midas <- cnv.wes.midas[,c(246,1:245)]
rm(a)

####合并GDSC和CNV突变信息####
total <- inner_join(gdsc,cnv.wes.midas,by="SANGER_MODEL_ID")

####读取SNP/indel突变信息####
#mutant文件中包含所有上述合并的total中所有968个细胞的突变信息
mutant.raw <- read.csv("../mutations_all_20260724.csv")
colnames(mutant.raw)
# a <- mutant.raw[!duplicated(mutant.raw$model_id),]$model_id
# length(intersect(a,total$SANGER_MODEL_ID))
# rm(a)
mutant <- mutant.raw[mutant.raw$model_id %in% total$SANGER_MODEL_ID &
                       mutant.raw$gene_symbol %in% MiDAS.genes,]
mutant$mutant_type <- ifelse(str_length(mutant$reference)==1 &
                               str_length(mutant$alternative)==1, "SNP", "indel")

mutant.snp <- mutant[mutant$mutant_type == "SNP",c("gene_symbol","model_id")]
mutant.snp <- mutant.snp %>%
  count(model_id, gene_symbol) %>%        
  pivot_wider(names_from = gene_symbol, 
              values_from = n, 
              values_fill = 0) 
colnames(mutant.snp)[1] <- "SANGER_MODEL_ID"
colnames(mutant.snp)[2:ncol(mutant.snp)] <- paste0(colnames(mutant.snp)[2:ncol(mutant.snp)],"_SNP")

mutant.indel <- mutant[mutant$mutant_type == "indel",c("gene_symbol","model_id")]
mutant.indel <- mutant.indel %>%
  count(model_id, gene_symbol) %>%        
  pivot_wider(names_from = gene_symbol, 
              values_from = n, 
              values_fill = 0) 
colnames(mutant.indel)[1] <- "SANGER_MODEL_ID"
colnames(mutant.indel)[2:ncol(mutant.indel)] <- paste0(colnames(mutant.indel)[2:ncol(mutant.indel)],"_indel")
rm(mutant.raw)

####合并total和SNP/indel突变信息####
total <- inner_join(total,mutant.snp,by="SANGER_MODEL_ID")
total <- full_join(total,mutant.indel,by="SANGER_MODEL_ID")
total[is.na(total)] <- 0

write.csv(total,"/mnt/NC/LJW/MiDAS_score/input/GDSC_input_data.2.0.csv")






