for i in $(bcftools query -l dataset1_rohs.vcf.gz);
do
echo "bad_words = "$i""

echo "with open("roh.txt") as old_file, open(""$i".txt","w") as newfile:
 for line in old_file:
  if any(bad_word in line for bad_word in bad_words):
   newfile.write(line)"
done
