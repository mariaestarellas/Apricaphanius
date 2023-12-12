{rm(list=ls())
  library(tidyverse)
  library(ggplot2)
  library(plotly)
  library(dplyr)
  setwd("~/Dropbox/FARTET/2.ANALYSES/2.WGS/PCA")
}

pca <- read_table("aph_iberus_pca.eigenvec", col_names = FALSE)
eigenval <- scan("aph_iberus_pca.eigenval")
pca <- pca[,-1]

names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
pca[,2:20] = pca[,2:20] * -1
col <- read.table("col.txt", header=T)
pca <- as.tibble(data.frame(pca, col$Species))
names(pca)[22] <- "Aphanius_iberus"

pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + theme_classic() + xlab("") + ylab("") + xlim(c(0,15)) + theme(axis.text.x = element_blank(),axis.ticks.x = element_blank(),axis.text.y = element_blank())

b <- ggplot(pca, aes(PC1, PC2, label=ind, colour=Aphanius_iberus,fill=Aphanius_iberus)) + geom_point(color="black",size = 5,shape=21)+ 
  theme_light()+ xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)"))+
  ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)")) +
  theme_classic() + theme(panel.border = element_rect(colour = "black", fill=NA, size=2), 
                          panel.grid.major = element_blank(), 
                          panel.grid.minor = element_blank(), 
                          axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5)) + ggtitle("Aphanius iberus") +
  scale_fill_manual(values = c("#A8E1E2", "#AC58C9", "#7F3DDF", "#CF8A69", "#789B85", "#73B8DD", "#8A6C8F", "#DBE99F", "#5ADED3", "#A0E5B5", "#73EE51", "#E6B1B1", "#DD464B", "#E247DD", "#DA88E1", "#6272DC", "#D4CBE7", "#E7963C", "#E3E2CC", "#69E195", "#D4BD71", "#D56989", "#8797DF", "#DEE048", "#E1A7D9", "#A7DE6A", "#E655B1")) #+ geom_mark_ellipse(aes(fill=Leopards,filter = Leopards == "African leopard"))

ggplotly(b)
