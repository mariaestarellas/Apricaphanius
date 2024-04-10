bad_words = ["ST"]

with open("roh.txt") as old_file, open("noST_roh.txt","w") as newfile:
 for line in old_file:
  if not any(bad_word in line for bad_word in bad_words):
   newfile.write(line)
