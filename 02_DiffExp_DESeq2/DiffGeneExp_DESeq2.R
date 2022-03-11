library("DESeq2")
countdata <- read.table("./all_exp.txt",sep="\t",header=T) ## input file 

## set gene names as the row names
len <- length(countdata)
rownames(countdata) <- countdata[,1]
countdata <- countdata[,2:len]

## 2 controls + 3 treatments
type <- c("Control","Control","Treat","Treat","Treat") 
coldata <- data.frame(type)

## execute DESeq2
dds <- DESeqDataSetFromMatrix(countData=countdata, colData=coldata, design = ~ type)
dds <- DESeq(dds)
result <- results(dds)
write.csv(result, file="./DiffGeneExp_DESeq2.csv") ## output csv file, can be opened by Excel

## extract differentially expressed genes, by setting 'padj < 0.05 && log2FoldChange > 1 or < -1'
filter_deseq2 <- subset(result, padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))
write.csv(filter_deseq2, file="./DiffGeneExp_DESeq2_Filter.csv") ## output csv file, can be opened by Excel

