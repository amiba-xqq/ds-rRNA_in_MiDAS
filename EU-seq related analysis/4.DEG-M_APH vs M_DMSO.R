rm(list = ls())  
library(tidyverse)
library(ggrepel)
library(clusterProfiler)
library(org.Hs.eg.db)
load(file = '1.counts.Rdata')
load(file = 'DEG_M_APHvsnoEU.Rdata')
load(file = 'DEG_M_APHvsDMSO.Rdata')
load(file = 'DEG_M_DMSOvsnoEU.Rdata')
####合并数据框####
a <- DEG_M_APHvsnoEU[,c("log2FoldChange","padj","geneid")]
colnames(a) <- c("log2FC_M_APHvsnoEU","padj_M_APHvsnoEU","geneid")

b <- DEG_M_APHvsDMSO[,c("log2FoldChange","padj","geneid")]
colnames(b) <- c("log2FC_M_APHvsDMSO","padj_M_APHvsDMSO","geneid")

total <- full_join(a,b,by="geneid")
total[is.na(total$log2FC_M_APHvsDMSO),]$log2FC_M_APHvsDMSO <- 0
total[is.na(total$padj_M_APHvsDMSO),]$padj_M_APHvsDMSO <- 1

table(total$log2FC_M_APHvsDMSO>log2(1.5) & total$padj_M_APHvsDMSO<0.05)
table(total$log2FC_M_APHvsnoEU>log2(1.5) & total$padj_M_APHvsnoEU<0.05)

total_upgene <- total[total$log2FC_M_APHvsDMSO>log2(1.5) &
                        total$padj_M_APHvsDMSO<0.05 &
                        total$log2FC_M_APHvsnoEU>log2(1.5) &
                        total$padj_M_APHvsnoEU<0.05,]
write.csv(total_upgene,"./DEG_M_APH_vs_M_DMSO_up/DEG_M_APH_vs_M_DMSO_up_gene.csv")

ggplot(total_upgene,aes(x = log2FC_M_APHvsnoEU, y = log2FC_M_APHvsDMSO))+
  geom_point(color = "orange",alpha=0.5,size=3)+
  geom_text_repel(label = total_upgene$geneid)+
  geom_hline(yintercept = log2(2), linetype = "dashed", color = "grey", linewidth=1)+
  geom_vline(xintercept = log2(2), linetype = "dashed", color = "grey", linewidth=1)+
  xlab("log2FC_M_APHvsnoEU")+
  ylab("log2FC_M_APHvsDMSO")+
  theme_classic(base_size = 16)
ggsave("./DEG_M_APH_vs_M_DMSO_up/DEG_M_APH_vs_M_DMSO_up_gene.pdf",
       width = 8, height = 8)

####获取下调gene####
a <- DEG_M_DMSOvsnoEU[,c("log2FoldChange","padj","geneid")]
colnames(a) <- c("log2FC_M_DMSOvsnoEU","padj_M_DMSOvsnoEU","geneid")

b <- DEG_M_APHvsDMSO[,c("log2FoldChange","padj","geneid")]
colnames(b) <- c("log2FC_M_APHvsDMSO","padj_M_APHvsDMSO","geneid")

total2 <- full_join(a,b,by="geneid")
total2[is.na(total2$log2FC_M_APHvsDMSO),]$log2FC_M_APHvsDMSO <- 0
total2[is.na(total2$padj_M_APHvsDMSO),]$padj_M_APHvsDMSO <- 1

total_downgene <- total2[total2$log2FC_M_APHvsDMSO< -log2(1.5) &
                        total2$padj_M_APHvsDMSO<0.05 &
                        total2$log2FC_M_DMSOvsnoEU>log2(1.5) &
                        total2$padj_M_DMSOvsnoEU<0.05,]
####获取上调gene####
#M_APH vs M_DMSO上调gene共155个
#M_APH vs M_DMSO下调gene共73个
gene_up <- total_upgene$geneid
#### 转化基因名为entrez ID ####
#org.Hs.eg.db\org.Mm.eg.db包含着各大主流数据库的数据，如entrez ID和ensembl,
#keytypes(org.Hs.eg.db) #查看所有支持及可转化类型 常用 "ENTREZID","ENSEMBL","SYMBOL"
#na.omit()用于从数据框或向量中删除包含缺失值（NA）的行
gene_up_entrez <- as.character(na.omit(bitr(gene_up, #数据集 
                                            fromType="SYMBOL", #输入格式
                                            toType="ENTREZID", # 转为ENTERZID格式
                                            OrgDb="org.Hs.eg.db")[,2])) #"org.Hs.eg.db" "org.Mm.eg.db" "org.Ce.eg.db",需要library加载对应的数据库
#### KEGG、GO富集-gene_down ####
kegg_enrich_results <- enrichKEGG(gene  = gene_up_entrez,
                                  organism  = "hsa", #物种人类 hsa 小鼠mmu 线虫cel
                                  pvalueCutoff = 0.05,
                                  qvalueCutoff = 0.2) #enrichKEGG有参数universe，用来设置背景基因集
kk_read <- DOSE::setReadable(kegg_enrich_results, 
                             OrgDb="org.Hs.eg.db", 
                             keyType='ENTREZID')#ENTREZID to gene Symbol
write.csv(kk_read@result,'./DEG_M_APH_vs_M_DMSO_up/KEGG_M_APH_vs_M_DMSO_up.csv') 

go_enrich_results <- enrichGO(gene = gene_up_entrez,
                              OrgDb = "org.Hs.eg.db",
                              ont   = "BP"  ,     #One of "BP", "MF"  "CC"  "ALL" 
                              pvalueCutoff  = 0.05,
                              qvalueCutoff  = 0.2,
                              readable      = TRUE)
write.csv(go_enrich_results@result, './DEG_M_APH_vs_M_DMSO_up/GO_BP_M_APH_vs_M_DMSO_up.csv') 

go_enrich_results_ALL <- enrichGO(gene = gene_up_entrez,
                                  OrgDb = "org.Hs.eg.db",
                                  ont   = "ALL"  ,     #One of "BP", "MF"  "CC"  "ALL" 
                                  pvalueCutoff  = 0.05,
                                  qvalueCutoff  = 0.2,
                                  readable      = TRUE)
write.csv(go_enrich_results_ALL@result, './DEG_M_APH_vs_M_DMSO_up/GO_ALL_M_APH_vs_M_DMSO_up.csv') 

####dotplot####
dotp <- enrichplot::dotplot(go_enrich_results,font.size =14,
                            x = "GeneRatio",
                            color = "p.adjust",
                            size = "Count",
                            showCategory = 8 #展示的通路个数
)+
  theme(legend.key.size = unit(10, "pt"),#调整图例大小
        plot.margin=unit(c(1,1,1,1),'lines'))#调整四周留白大小
ggsave(dotp,filename = './DEG_M_APH_vs_M_DMSO_up/GO_BP_M_APH_vs_M_DMSO_up_dotplot.pdf',width =8,height =6)

dotp <- enrichplot::dotplot(kegg_enrich_results,font.size =14,
                            x = "GeneRatio",
                            color = "p.adjust",
                            size = "Count",
                            showCategory = 8)+
  theme(legend.key.size = unit(10, "pt"),#调整图例大小
        plot.margin=unit(c(1,1,1,1),'lines'))#调整四周留白大小
ggsave(dotp,filename = './DEG_M_APH_vs_M_DMSO_up/KEGG_M_APH_vs_M_DMSO_up_dotplot.pdf',width =8,height =6)

dotp <- enrichplot::dotplot(go_enrich_results_ALL,font.size =12,
                            x = "GeneRatio",
                            color = "p.adjust",
                            size = "Count",
                            showCategory = 8,
                            split = 'ONTOLOGY')+
  facet_grid(ONTOLOGY~., scale="free")+ 
  theme(legend.key.size = unit(10, "pt"),#调整图例大小
        plot.margin=unit(c(1,1,1,1),'lines'))#调整四周留白大小
ggsave(dotp,filename = './DEG_M_APH_vs_M_DMSO_up/GO_ALL_M_APH_vs_M_DMSO_up_dotplot.pdf',width =8,height =8)

####挑选所有Histone mRNA做热图####
histone <- gene_up[grepl("^H[234]", gene_up)]
dat <- log2(cpm_filt+1)
n <- dat[histone,
         c("noEU","Asyn_DMSO_r1","Asyn_DMSO_r2","Asyn_APH_r1","Asyn_APH_r2",
           "M_DMSO_r1","M_DMSO_r2","M_APH_r1","M_APH_r2")]
cg <- names(tail(sort(apply(n,1,sd)),length(histone))) 
n <- n[cg,]
p1 <- pheatmap::pheatmap(n,show_colnames =T,show_rownames = T,
                         fontsize=7,
                         legend_breaks = -3:3,
                         scale = "row",
                         angle_col=45,
                         annotation_col=gl,
                         cluster_cols=F)
p1
ggsave(p1,filename = './DEG_M_APH_vs_M_DMSO_up/heatmap_M_APH_vs_M_DMSO_up_histone_gene.pdf',
       width = 5,height =5)








