library(pheatmap)

## input count matrix
countdata <- read.table("./all_exp.txt",sep="\t",header=T) ## input file

## set gene names as the row names
len <- length(countdata)
rownames(countdata) <- countdata[,1]
countdata <- countdata[,2:len]

## doing log10 for all values. All number 0 should be changed to 0.001 before that.  
countdata[countdata == 0] <- 0.001
lcountdata <- log(countdata)/log(10)

# Heat map
pdf("./pheatmap_Diff_Exp.pdf")
pheatmap(lcountdata)
