
def create_movie_dic(x):
	d = {}
	for i in iter(x):
		d[i] = i
	return d

f1 = open("actress_movies.txt")

final = list()

for line in iter(f1):
	temp = map(str.strip, line.strip().split("\t\t"))
	dict = {}
	dict['actor'] = temp[0]
	dict['movies'] = create_movie_dic(temp[1:len(temp)])
	if len(temp) -1 >= 5 :
		final.append(dict)

f2 = open("actor_movies.txt")
for line in iter(f2):
	temp = map(str.strip, line.strip().split("\t\t"))
	dict = {}
	dict['actor'] = temp[0]
	dict['movies'] = create_movie_dic(temp[1:len(temp)])
	if len(temp) -1 >= 5 :
		final.append(dict)


def intersection(m1, m2):
	count = 0
	for x in m1:
		if m2.has_key(x):
			count = count + 1
	return count

t = len(final)

f = open("final.txt", "w")


for i in range(0,t):
	print(i)
	movies1 = final[i]['movies']
	for j in range(i+1,t):
		movies2 = final[j]['movies']
		count = intersection(movies1, movies2)
		if count > 0:
			f.write(final[i]['actor']+"	"+final[j]['actor']+"	"+`float(count)/len(movies1)` + "\n" )
			f.write(final[j]['actor']+"	"+final[i]['actor']+"	"+`float(count)/len(movies2)` + "\n")
				# add edge from final[i][0] to final[j][0] with weight count / len(final[i]-1)
				# add edge from final[j][0] to final[i][0] with weight count / len(final[j]-1)



f.close()
	





