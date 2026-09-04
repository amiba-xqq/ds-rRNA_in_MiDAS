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
  filter(str_detect(Gene, "^(ONE_GENE|TWO_GENES)")) %>%  
  pull(Gene) %>%                                         
  str_extract_all("(?<=:)[^;]+(?=;)") %>%              
  unlist() %>%                                          
  unique() 

####读取细胞信息####
#download from https://depmap.org/portal/data_page/?tab=allData&releasename=CCLE%202019&filename=Cell_lines_annotations_20181226.txt
ccle.cell <- read.table("../CCLE/Cell_lines_annotations_20181226.txt",
                        sep = "\t",fill = T)
a <- as.character(ccle.cell[1,])
colnames(ccle.cell) <- a
ccle.cell <- ccle.cell[-1,]

####读取药物敏感性信息####
#download from https://depmap.org/portal/data_page/?tab=allData&releasename=Sanger%20GDSC1%20and%20GDSC2&filename=sanger-dose-response.csv
ccle.drug <- read.csv("../CCLE/sanger-dose-response.csv")
a <- ccle.drug[!duplicated(ccle.drug$DRUG_NAME),]
RS.drug <- c("Niraparib","5-Fluorouracil","Oxaliplatin","Epirubicin","VE-821","Camptothecin",
              "MK-8776, SCH900776","Irinotecan","Teniposide","AZD6738","Topotecan","VE-822",
              "Methotrexate","SN-38","Olaparib","Cyclophosphamide",
              "Talazoparib","Veliparib","AZD7762","Wee1 Inhibitor","Rucaparib",
              "Temozolomide","AZ20","Cisplatin","Etoposide") #GDSC数据库中挑选的25种复制压力型药物
RS.drug <- toupper(RS.drug)

ccle.drug.rs <- ccle.drug[ccle.drug$DRUG_NAME %in% RS.drug,
                          c("ARXSPAN_ID","DRUG_NAME","Z_SCORE_PUBLISHED")]
ccle.drug.rs <- ccle.drug.rs %>%
  group_by(ARXSPAN_ID) %>%                  
  summarise(Z_SCORE_PUBLISHED = mean(Z_SCORE_PUBLISHED, na.rm = TRUE)) %>%  #对于每种细胞，取药物的Z-score且取均值
  ungroup()
colnames(ccle.drug.rs) <- c("depMapID","DRUG_Z_score")
ccle.drug.rs <- ccle.drug.rs[ccle.drug.rs$depMapID!="",]

####读取MiDAS gene的CN信息####
#download from https://depmap.org/portal/data_page/?tab=allData&releasename=DepMap%20Public%2026Q1&filename=OmicsCNGeneWGS.csv
ccle.cnv <- read.csv("../CCLE/OmicsCNGeneWGS.csv",row.names = 1)
ccle.cnv <- ccle.cnv[,c(3,6:ncol(ccle.cnv))]
colnames(ccle.cnv)[2:ncol(ccle.cnv)] <- sub("\\.\\..*", "", colnames(ccle.cnv)[2:ncol(ccle.cnv)])
ccle.cnv <- ccle.cnv[,c("ModelID",colnames(ccle.cnv)[colnames(ccle.cnv) %in% MiDAS.genes])]
colnames(ccle.cnv)[2:ncol(ccle.cnv)] <- paste0(colnames(ccle.cnv)[2:ncol(ccle.cnv)],"_CNV")
colnames(ccle.cnv)[1] <- "depMapID"
ccle.cnv[is.na(ccle.cnv)] <- 1
ccle.cnv <- ccle.cnv %>%
  mutate(across(-1, ~ . * 2))

####合并数据####
ccle.total <- inner_join(ccle.drug.rs,ccle.cnv,by="depMapID")
write.csv(ccle.total,"/mnt/NC/LJW/MiDAS_score/input/test_CCLE.csv")















