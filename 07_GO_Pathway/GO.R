#installation
# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("clusterProfiler")

library(clusterProfiler)
#BiocManager::install('org.Hs.eg.db',force = TRUE)
library(org.Hs.eg.db)


#prepare gene list
d = read.csv("DiffGeneExp_DESeq2.csv")
## 1st column is ID
## 2nd column is basemean
## 3rd column is log2FC

## feature 1: numeric vector
geneList = d[,3]
## feature 2: named vector
names(geneList) = as.character(d[,1])
## feature 3: decreasing order
geneList = sort(geneList, decreasing = TRUE)


####################### GO ANALYSIS #########################

#1 GO classification
# Entrez gene ID
gene <- names(geneList)[abs(geneList) > 2]
head(gene)

#suboncotology: CC
ggo <- groupGO(gene     = gene,
               OrgDb    = org.Hs.eg.db,
               ont      = "CC",
               level    = 3,
               readable = TRUE)#if readable is TRUE, the gene IDs will mapping to gene symbols.
head(ggo)


#2 GO over-representation analysis
ego <- enrichGO(gene          = gene,
                universe      = names(geneList),
                OrgDb         = org.Hs.eg.db,
                ont           = "CC",
                pAdjustMethod = "BH",
                pvalueCutoff  = 0.01,
                qvalueCutoff  = 0.05,
                readable      = TRUE)
head(ego,3)


#3 GO Gene Set Enrichment Analysis
#The clusterProfiler package provides the gseGO() function for
#gene set enrichment analysis using gene ontology.
ego3 <- gseGO(geneList     = geneList,
              OrgDb        = org.Hs.eg.db,
              ont          = "CC",
              minGSSize    = 10,
              maxGSSize    = 500,
              pvalueCutoff = 0.05,
              )

head(ego3,3)


## Visualization of functional enrichment result
#directed acyclic graph
goplot(ego)

#Bar plot
library(DOSE)
edo <- enrichDGN(gene)
library(enrichplot)
barplot(edo, showCategory=20) 

#Dot plot
edo2 <- gseDO(geneList)
dotplot(edo, showCategory=30) + ggtitle("dotplot for ORA")
dotplot(edo2, showCategory=30) + ggtitle("dotplot for GSEA")

#showing specific pathways
de <- names(geneList)[1:100]

x <- enrichDO(de)

## show top 10 most significant pathways and want to exclude the second one
## dotplot(x, showCategory = x$Description[1:10][-2])

set.seed(2022-4-26)
selected_pathways <- sample(x$Description, 10)
selected_pathways

p1 <- dotplot(x, showCategory = 10, font.size=14)
p2 <- dotplot(x, showCategory = selected_pathways, font.size=14)

#install.packages("cowplot")
cowplot::plot_grid(p1, p2, labels=LETTERS[1:2])


#Enrichment map
#install.packages("ggnewscale")
edo <- pairwise_termsim(edo)
p1 <- emapplot(edo)
p2 <- emapplot(edo, cex_category=1.5)
p3 <- emapplot(edo, layout="kk")
p4 <- emapplot(edo, cex_category=1.5,layout="kk") 
cowplot::plot_grid(p1, p2, p3, p4, ncol=2, labels=LETTERS[1:4])



####################### KEGG PATHWAY ANALYSIS #########################
library(clusterProfiler)
search_kegg_organism('hsa', by='kegg_code')

human <- search_kegg_organism('hsa', by='kegg_code')
#human <- search_kegg_organism('Homo sapiens', by='scientific_name')
dim(human)
head(human,3)


## KEGG pathway over-representation analysis
## following GO analysis, genelist preparation is same as in 2.3

kk <- enrichKEGG(gene         = gene,
                 organism     = 'hsa',
                 pvalueCutoff = 0.05)
head(kk,3)


## KEGG pathway gene set enrichment analysis
kk2 <- gseKEGG(geneList     = geneList,
               organism     = 'hsa',
               minGSSize    = 120,
               pvalueCutoff = 0.05,
               verbose      = FALSE)
head(kk2,3)

## Visualize enriched KEGG pathways
browseKEGG(kk, 'hsa04110')
