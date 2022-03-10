library(EnhancedVolcano)

## input the result from edgeR
inputFileName="./DiffGeneExp_edgeR.csv" 
exp_data <- read.csv(inputFileName, header=TRUE)

## set gene names as the row names
len <- length(exp_data)
rownames(exp_data) <-exp_data[,1]
exp_data <- exp_data[,2:len]

## change values to numeric
exp_data$logFC=as.numeric(exp_data$logFC)
exp_data$FDR=as.numeric(exp_data$FDR)

## plot the figure, for log2FlodChange and FDR.
pdf("Volcano_For_edgeR.pdf")
EnhancedVolcano(exp_data,
lab = rownames(exp_data),
    x = 'logFC',
    y = 'FDR')
