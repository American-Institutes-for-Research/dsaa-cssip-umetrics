import sys


infile = sys.argv[1]
outfile = sys.argv[1] + "CLEAN"

delete_list = ["DEFINER=`root`@`localhost`"]
fin = open(infile, encoding="utf-8")
fout = open(outfile, "w+", encoding="utf-8")
for line in fin:
    for word in delete_list:
        line = line.replace(word, "")
    fout.write(line)
fin.close()
fout.close()