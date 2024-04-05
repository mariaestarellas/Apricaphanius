bad_words = ["ST"]

with open("roh_filtered.txt") as old_file, open("new_file.txt","w") as newfile:
 for line in old_file:
  if not any(bad_word in line for bad_word in bad_words):
   newfile.write(line)
