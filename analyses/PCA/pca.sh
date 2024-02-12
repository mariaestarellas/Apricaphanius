#First of all you need to create a fam, a bed and a bim file for your vcf (usnps):
plink --vcf/home/goliath/DiscoC/aphanius/copy_data/filtered/haplotypecaller/genotypecaller/filtervcf/1.all_aphanius/dataset2_rmrep_gatk_nomissing_usnps05.vcf.gz --allow-extra-chr --double-id --make-bed --out aph_iberus_nomissing

#With plink, you create the .eigenvec and .eigenval files that you will use for the PCA:
plink --bfile aph_iberus_nomissing --double-id --allow-extra-chr --set-missing-var-ids @:# --make-bed --pca --mind --out aph_iberus_nomissing_pca
