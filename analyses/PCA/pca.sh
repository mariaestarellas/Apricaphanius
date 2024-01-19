#First of all you need to create a fam, a bed and a bim file for your vcf:
plink --vcf /home/goliath/DiscoC/aphanius/copy_data/filtered/haplotypecaller/genotypecaller/filtervcf/dataset2_filtered_usnps05.vcf.gz --allow-extra-chr --double-id --make-bed --out aph_iberus

#With plink, you create the .eigenvec and .eigenval files that you will use for the PCA:
plink --bfile aph_iberus --double-id --allow-extra-chr --set-missing-var-ids @:# --make-bed --pca --mind --out aph_iberus_pca
