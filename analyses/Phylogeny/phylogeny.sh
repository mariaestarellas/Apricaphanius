#1 Create consensus

for i in $(cat names.txt);
do
angsd -i "$i"_mkdup_30.bam -doFasta 3 -out /home/goliath/DiscoC/aphanius/analyses/phylogeny/"$i"
done

#2 Remove headers
#in order to use grep, we need to unzip the fq files:
gunzip *gz

#we will remove the contig names in the file:

for i in $(ls ~/DiscoC/aphanius/analyses/phylogeny/*fa); do grep -v ">" "$directory""$i" > "$i"_no_chr.fa; done

#3 Add label
#we need to add the label name to each file. IMPORTANT, this will not work if there is more than one dot in the file_name!
for i in $(ls *fa);
do
id=$(echo $i |cut -d . -f1) 
sed -i "1 i\>$id" $i
done

#4 1 file and 1 line
#one file:
cat *no_chr.fa > all_sequences.fa
#one line
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < all_sequences.fa > sliding_windows_aphanius_one_line.fa

#5 Sliding windows
seqkit sliding good_all_sequences.fa -s 1000000 -W 1000000 > sliding_windows_aphanius.fa

#You make sure that each observation is only in one line
bash all_sequences_one_line.sh sliding_windows_leopards.fa


#I don't know why in the first line there is an empty space, so we remove it:
tail -n +2 sliding_windows_leopards_one_line.fa > sliding_windows_leopards_one_line.tmp && mv sliding_windows_leopards_one_line.tmp sliding_windows_leopards_one_line.fa
