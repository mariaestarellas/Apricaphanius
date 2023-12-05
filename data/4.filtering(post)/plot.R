setwd ("~/DiscoC/aphanius/copy_data/filtered/haplotypecaller/genotypecaller/filtervcf/")
library(ggplot2)
dataset <- read.delim("dataset3.table")
y <- c("QD", "FS", "SOR", "MQ", "MQRankSum", "ReadPosRankSum")
for (i in y){
pdf(file= paste0(i,".pdf"))
ggplot(dataset, aes(x= i)) + geom_density(color="darkblue", fill="lightblue")
dev.off()
}
