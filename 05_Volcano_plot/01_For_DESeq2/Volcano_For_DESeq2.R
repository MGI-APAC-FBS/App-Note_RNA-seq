library(EnhancedVolcano)

## input the result from DESeq2
inputFileName="./DiffGeneExp_DESeq2.csv" 
exp_data <- read.csv(inputFileName, header=TRUE)

## set gene names as the row names
len <- length(exp_data)
rownames(exp_data) <-exp_data[,1]
exp_data <- exp_data[,2:len]

## change values to numeric
exp_data$log2FoldChange=as.numeric(exp_data$log2FoldChange)
exp_data$padj=as.numeric(exp_data$padj)

## plot the figure, for log2FlodChange and padj.
pdf("Volcano_For_DESeq2.pdf")
EnhancedVolcano(exp_data,
lab = rownames(exp_data),
    x = 'log2FoldChange',
    y = 'padj')
