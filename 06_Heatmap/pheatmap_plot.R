# install.packages("pheatmap")
library(pheatmap)

# Data 
set.seed(8)
m <- matrix(rnorm(200), 10, 10)
colnames(m) <- paste("Col", 1:10)
rownames(m) <- paste("Row", 1:10)

# Heat map
pheatmap(m)
