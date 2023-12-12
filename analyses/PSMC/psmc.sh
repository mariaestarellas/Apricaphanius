# PSMC

1) We need a .bam file as an input and the reference genome. This analysis is done for each sample (which needs to be at higher coverage). We need to set -d to 1/3 of our coverage and -D to the double (given that our coverage is 13.8)

bcftools mpileup -C50 -f whole_path/reference.fa CN21596.bam | bcftools call -c - | vcfutils.pl vcf2fq -d 4.6  -D 27.6 | gzip > CN21596_diploid.fq.gz

/home/panthera/software/psmc/utils/fq2psmcfa -q20 CN21596_diploid.fq.gz > CN21596_diploid.psmcfa 

2) Now we can run psmc:

psmc –N25 -t150 -r2 -p "4+25*2+4+6" -o CN21596_diploid.psmc CN21596_diploid.psmcfa

3) Time to Plot.
We need to take into consideration which is the generation time (-g) which in our case is 2 per year and the mutation rate (-u) which is 3.5x10-9 bp/generation. 

softwares/psmc/utils/psmc_plot.pl -u 3.5e-9 -g 0.5 diploid diploid.psmc 

4) Finally bootstrap (10)
Firts, we need to split the psmcfa file into shorter fragments. 

/home/panthera/software/psmc/utils/splitfa CN21596_diploid.psmcfa > CN21596_split.psmcfa

Now do an iterative loop to do 10 rounds. Don't forget the -b flag!

for i in $(seq 1 10);
> do
> /home/panthera/software/psmc/psmc -N25 -t5 -r2 -b -p "4+25*2+4+6" -o CN21596_round"$i".psmc CN21596_split.psmcfa
> done

cat *round* CN21596_diploid.psmcfa > CN21596_combined_bs.psmc

psmc_plot.pl -u 3.5e-9 -g 0.5 CN21596_bs CN21596_combined_bs.psmc
