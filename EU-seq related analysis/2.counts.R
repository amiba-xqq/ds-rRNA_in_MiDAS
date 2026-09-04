####环境设置####
rm(list=ls())
options(stringsAsFactors = F) 
library(tidyverse) # ggplot2 stringer dplyr tidyr readr purrr  tibble forcats
library(data.table) #多核读取文件

#### 对counts进行处理筛选得到表达矩阵 ####
a1 <- fread('../counts_RNAseq.txt',
            header = T,data.table = F)#载入counts，第一列设置为列名
colnames(a1)
counts <- a1[,7:ncol(a1)] #截取样本基因表达量的counts部分作为counts 
rownames(counts) <- a1$Geneid #将基因名作为行名
####更改样品名####
colnames(counts)
colnames(counts) <- gsub('sortedname.bam','',  colnames(counts)) #删除样品名后缀
####导入或构建样本信息,  进行列样品名的重命名和分组####
name_list <- colnames(counts) #选择所需要的样品信息列
nlgl <- data.frame(row.names=colnames(counts),
                   name_list=colnames(counts),
                   group_list= c("Asy_APH","Asy_APH","Asy_DMSO","Asy_DMSO",
                                 "M_APH","M_APH","M_DMSO","M_DMSO","noEU"))
fix(nlgl)  #手动编辑构建样品名和分组信息
name_list <- nlgl$name_list
group_list <- nlgl$group_list
gl <- data.frame(row.names=colnames(counts), #构建样品名与分组对应的数据框
                 group_list=group_list)

#### counts，CPM转化 ####
col_sums <- colSums(counts)
cpm <- counts
i=1
repeat{
  cpm[,i] <- cpm[,i]/col_sums[i]*1e6
  i=i+1
  if(i>ncol(cpm)){
    break
  }
}
colSums(cpm)
####合并所有重复symbol####
g2s <- fread('g2s_vm25_gencode.txt',header = F,data.table = F) #载入从gencode的gtf文件中提取的信息文件
colnames(g2s) <- c("geneid","symbol")

symbol <- g2s[match(rownames(counts),g2s$geneid),"symbol"] #匹配counts行名对应的symbol
table(duplicated(symbol))  #统计重复基因名

####使用aggregate根据symbol列中的相同基因进行合并####
counts_symbol <- aggregate(counts, by=list(symbol), FUN=sum)
counts_symbol <- column_to_rownames(counts_symbol,'Group.1')
counts_symbol <- counts_symbol[-1,]
cpm_symbol <- aggregate(cpm, by=list(symbol), FUN=sum) ###使用aggregat 将symbol列中的相同基因进行合并 
cpm_symbol <- column_to_rownames(cpm_symbol,'Group.1')
cpm_symbol <- cpm_symbol[-1,]

dir.create("results")
write.csv(cpm_symbol, file="./results/cpm_symbol.csv")

####初步过滤低表达基因####
#筛选出至少在重复样本数量内的表达量counts大于1的行（基因）
keep_feature <- rowSums(counts_symbol>1) >= 2
table(keep_feature)  #查看筛选情况，FALSE为低表达基因数（行数），TURE为要保留基因数

counts_filt <- counts_symbol[keep_feature, ] #替换counts为筛选后的基因矩阵（保留较高表达量的基因）
cpm_filt <- cpm_symbol[keep_feature, ]

#### 保存数据 ####
save(counts, cpm,cpm_filt,counts_filt,
     group_list, gl,
     file='1.counts.Rdata') 
