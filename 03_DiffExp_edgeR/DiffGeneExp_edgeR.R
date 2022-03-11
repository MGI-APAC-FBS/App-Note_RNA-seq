library(edgeR)

## input count matrix
countdata <- read.table("./all_exp.txt",sep="\t",header=T) ## input file

## set gene names as the row names
len <- length(countdata)
rownames(countdata) <- countdata[,1]
countdata <- countdata[,2:len]

## make DGEList
type <- c("Control","Treat") ## one control, one treatment
y<-DGEList(counts=countdata,group=type)

## filter  genes with low expression
keep = filterByExpr(y)
y = y[keep,,keep.lib.sizes = FALSE]

## standardization
y = calcNormFactors(y)

## differential expressed genes calculation, use a loose BCV value
y_bcv <- y
bcv <- 0.2
diffExp <- exactTest(y_bcv,dispersion = bcv ^ 2)

## extract result
result = topTags(diffExp, n =90000)
write.csv(result, file="./DiffGeneExp_edgeR.csv") ## output csv file, can be opened by Excel

## extract differentially expressed genes, by setting 'FDR < 0.05 && logFC > 1 or < -1'
result<- as.data.frame(result)
result_DEG = subset(result, FDR < 0.05 & (logFC > 1 | logFC < -1))
write.csv(result_DEG, file="./DiffGeneExp_edgeR_Filter.csv") ## output csv file, can be opened by Excel
