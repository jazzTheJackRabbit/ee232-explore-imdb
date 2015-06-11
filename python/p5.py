f1 = open("movie_genre.txt")
f = open("mov_gen.txt", "w")

dict = {}

for line in iter(f1):
	temp = map(str.strip, line.strip().split("\t\t"))
	dict[temp[0]] = temp[1]

f2 = open("abc.txt")

for line in iter(f2):
	if(dict.has_key(line.strip())):
		f.write(line.strip()+"	"+dict[line.strip()]+"\n")
	else:
		f.write(line.strip()+"	NA"+"\n")

f1.close()
f.close()
f2.close()