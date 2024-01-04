# PSMC

#1) We need a .bam file as an input and the reference genome. This analysis is done for each sample (which needs to be at higher coverage). We need to set -d to 1/3 of our coverage and -D to the double

bcftools mpileup -C50 -f ~/DiscoC/aphanius/copy_data/reference_genome/assembly/AphaniusSeq_MaSuRCA-polished.fa /home/goliath/DiscoC/aphanius/copy_data/filtered/high_coverage/AT30199_mkdup_30.bam | bcftools call -c - | vcfutils.pl vcf2fq -d 5.23  -D 31.43 | gzip > AT30199_diploid.fq.gz

#-q is the quality filtering
/home/panthera/software/psmc/utils/fq2psmcfa -q20 CN21596_diploid.fq.gz > CN21596_diploid.psmcfa 
/home/goliath/software/psmc/utils/fq2psmcfa -q20 AT30199_diploid.fq.gz > AT30199_diploid.psmcfa
 
#2) Now we can run psmc:

psmc –N25 -t150 -r2 -p "4+25*2+4+6" -o CN21596_diploid.psmc CN21596_diploid.psmcfa

#3) Time to Plot.
#We need to take into consideration which is the generation time (-g) which in our case is 2 per year and the mutation rate (-u) which is 3.5x10-9 bp/generation. 

softwares/psmc/utils/psmc_plot.pl -u 3.5e-9 -g 0.5 diploid diploid.psmc 

#4) Finally bootstrap (10)
#First, we need to split the psmcfa file into shorter fragments. 

/home/panthera/software/psmc/utils/splitfa CN21596_diploid.psmcfa > CN21596_split.psmcfa

#Now do an iterative loop to do 10 rounds. Don't forget the -b flag!

for i in $(seq 1 10);
> do
> /home/panthera/software/psmc/psmc -N25 -t5 -r2 -b -p "4+25*2+4+6" -o CN21596_round"$i".psmc CN21596_split.psmcfa
> done

cat *round* CN21596_diploid.psmcfa > CN21596_combined_bs.psmc

psmc_plot.pl -u 3.5e-9 -g 0.5 CN21596_bs CN21596_combined_bs.psmc
