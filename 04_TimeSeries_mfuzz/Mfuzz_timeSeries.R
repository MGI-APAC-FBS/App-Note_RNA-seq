library("Mfuzz")

## input matrix
data<-table2eset("./all_exp.txt") ## input file

## data triming, get rid of odd number
data.r <- filter.NA(data, thres=0.25)
data.m <- fill.NA(data.r,mode="mean")
data.f <- filter.std(data.m,min.std=0.05,visu=F)

## standardization
data.s <- standardise(data.f)

## cluster based on fuzzy c-means
cl <- mfuzz(data.s,c=12,m=1.25)

## plot
pdf("TimeSeries.mfuzz.plot.pdf",width=7,height=9) ## output cluster figure
mfuzz.plot2(data.s,cl=cl,mfrow=c(4,3),min.mem=0.75,time.labels=c("day1","day2","day3","day4","day5"),x11 = FALSE)
dev.off()
pdf("TimeSeries.mfuzz.plot.split.pdf",width=7,height=9) ## another cluster figure, one figure per page
mfuzz.plot2(data.s,cl=cl,mfrow=c(1,1),min.mem=0.75,time.labels=c("day1","day2","day3","day4","day5"),x11 = FALSE)

## output
cluster<-cl$cluster
expStandard<-exprs(data.s)
write.table(cluster,file="TimeSeries.mfuzz.cluster") ## output cluster information
write.table(expStandard,file="TimeSeries.mfuzz.expStandard") ## out up/down regulation across different samples
dev.off()

