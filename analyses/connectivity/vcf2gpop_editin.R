#Script edited by Sergi and Maria
#Super important: 
#1) you need >1 individual per population
#2) the VCF needs to contain the names exactly as in the Individuals tab of the POPS.txt
#3) I ended up changing the loci names for SNP1-X in a same line.

install.packages("remotes")
remotes::install_github("spflanagan/gwscaR")
library(gwscaR)
library(dplyr)

vcf = parse.vcf("snp-thin.recode_edited.vcf")
vcf = as.data.frame(vcf)
pop_map = read.table("new_pops2.txt", header = T)
pop_map = as.data.frame(pop_map)
pop_list = as.list(unique(pop_map$STRATA))
gpop.name = "sergi2_genepop"


vcf2gpop(vcf, pop.list = pop_list, pop.map = pop_map, gpop.name = "./sergi2_genepop")

vcf2gpop<-function(vcf, pop.list = pop_list, pop.map = pop_map, gpop.name = "./sergi2_genepop"){#without the SNP column
  locusids<-paste(vcf$`#CHROM`,as.character(vcf$POS),sep="_")
  locusids<-gsub("\\.","_",locusids)
  indids<-colnames(vcf)[10:ncol(vcf)]
  gpop.mat<-extract.gt.vcf(vcf[,colnames(vcf)!="SNP"])
  
  #gpop[0 <- gpop[1]
  #1 <- gpop[2]
  gpop[gpop=="0/0" | gpop=="0|0"]<-"0/0"
  gpop[gpop=="0/1" | gpop=="0|1"]<-"0/1"
  gpop[gpop=="1/0" | gpop=="1|0"]<-"1/0"
  gpop[gpop=="1/1" | gpop=="1|1"]<-"1/1"
  gpop3 <- gpop
  for(i in 1:ncol(gpop)){
    for(j in 3:nrow(gpop)){
    temp <- gpop[j,i]
    v <- as.vector(strsplit(temp,"/"))
    vector <- as.character(v[[1]])
    if (vector[1] == "0"){
      b1 <- gpop[1,i]
    }
    else
      b1 <- gpop[2,i]
    if (vector[2] == "0"){
      b2 <- gpop[1,i]
    }
    else
      b2 <- gpop[2,i]
    gpop3[j,i] <- paste(b1,b2, sep="/")
    }
  }
  
  gpop3[gpop3=="A/A"] <-"001001"
  gpop3[gpop3=="A/C"] <-"001002"
  gpop3[gpop3=="A/G"] <-"001003"
  gpop3[gpop3=="A/T"] <-"001004"
  gpop3[gpop3=="C/A"] <-"002001"
  gpop3[gpop3=="C/C"] <-"002002"
  gpop3[gpop3=="C/G"] <-"002003"
  gpop3[gpop3=="C/T"] <-"002004"
  gpop3[gpop3=="G/A"] <-"003001"
  gpop3[gpop3=="G/C"] <-"003002"
  gpop3[gpop3=="G/G"] <-"003003"
  gpop3[gpop3=="G/T"] <-"003004"
  gpop3[gpop3=="T/A"] <-"004001"
  gpop3[gpop3=="T/C"] <-"004002"
  gpop3[gpop3=="T/G"] <-"004003"
  gpop3[gpop3=="T/T"] <-"004004"
  
  utils::write.table(locusids,gpop.name,sep='\n',quote=FALSE,
                     col.names = paste("Title line: ",gpop.name,sep=""),row.names=FALSE)
  if(!is.null(pop.list)){
    for(i in 1:length(pop.list)){
      pop<-gpop3[grep(pop.list[i],rownames(gpop3)),,drop=FALSE]
      utils::write.table(paste("POP",pop.list[i],sep=" "),gpop.name,quote=FALSE,col.names = FALSE,row.names=FALSE,append=TRUE)
      rownames(pop)<-paste(rownames(pop),",",sep="")
      utils::write.table(pop,gpop.name,quote=FALSE,col.names=FALSE,row.names=TRUE,sep=" ",append=TRUE)
    }
  } else if(!is.null(pop.map)){
    for(i in 1:length(unique(pop.map[,2]))){
      
      pname<-unique(pop.map[,2])[i]
      pop<-gpop3[rownames(gpop3) %in% pop.map[pop.map[,2]%in%pname,1],,drop=FALSE]
      if(nrow(pop)>0){
        utils::write.table(paste("POP",pname,sep=" "),gpop.name,quote=FALSE,col.names = FALSE,row.names=FALSE,append=TRUE)
        rownames(pop)<-paste(rownames(pop),",",sep="")
        utils::write.table(pop,gpop.name,quote=FALSE,col.names=FALSE,row.names=TRUE,sep=" ",append=TRUE)
      }
    }
  } else {
    stop("Must provide a pop.list or pop.map")
  }
  colnames(gpop)<-locusids
  return(gpop)
}



