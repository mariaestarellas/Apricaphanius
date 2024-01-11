#It's super important that the .txt file is empty/doesn't exist when we run the script!!

vcf="/home/goliath/DiscoC/aphanius/copy_data/filtered/haplotypecaller/genotypecaller/dataset3.vcf.gz"
sample="CN21784"

for region in $(cat complete_windows.txt);
do
callable=$(tabix -h $vcf $region | vcftools --gzvcf - --indv $sample --remove-indels --max-alleles 2 --minQ 30 --minDP 2 --maxDP 300 --stdout --recode --recode-INFO-all | grep -v '#' | wc -l ) 
	if [ $callable -gt 0 ];
	then
		value=${region#*:}
		start=$(echo "$value" |cut -d- -f1)
		chrom=$(echo "$region" |cut -d: -f1)
		tabix -h $vcf $region | vcftools --gzvcf - --indv $sample --remove-indels --max-alleles 2 --minQ 30 --minDP 2 --maxDP 300 --stdout --recode --recode-INFO-all | vcflib vcfhetcount | tail -n 1 | awk -v l="$callable" -v chrom="$chrom" -v start="$start" '{print chrom"\t"start+50000"\t"$1"\t"l"\t"$1/l}' | tee -a "$sample"_heterozygosity.txt
	else
		echo $line | awk -v l=0 -v het=NA '{print $1"\t"$2+50000"\t"l"\t"l"\t"het}' | tee -a "$sample"_heterozygosity.txt
	fi
done
