setwd ("~/DiscoC/aphanius/copy_data/filtered/haplotypecaller/genotypecaller/filtervcf/")
library(ggplot2)
dataset <- read.delim("dataset3.table")
y <- c("QD", "FS", "SOR", "MQ", "MQRankSum", "ReadPosRankSum")

for (i in y) {
  pdf(file = paste0(i, ".pdf"))
  print(ggplot(dataset, aes(x = get(i))) + 
          geom_density(color = "darkblue", fill = "lightblue"))
  dev.off()                                   
}
