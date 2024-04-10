with open("samples.txt") as fh:
    for i in fh:
        i = i.strip()
        bad_words = i
        
        with open("noST_roh.txt") as old_file, open(f"{i}.txt", "w") as newfile:
            for line in old_file:
                if bad_words in line:
                    newfile.write(line)
