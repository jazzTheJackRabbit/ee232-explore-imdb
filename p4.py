f1 = open("movie_genre.txt")

m = {}

for line in iter(f1):
	temp = map(str.strip, line.strip().split("\t\t"))
	dict = {}
	dict["actor"] = {}
	dict["genre"] = temp[1]
	m[temp[0]] = dict

f1.close()

f2 = open("actress_movies.txt")

for line in iter(f2):
	temp = map(str.strip, line.strip().split("\t\t"))
	for i in iter(temp[1:len(temp)]):
		if(m.has_key(i)):
			m.get(i)["actor"][temp[0]] = temp[0]

f3 = open("actor_movies.txt")
for line in iter(f3):
	temp = map(str.strip, line.strip().split("\t\t"))
	for i in iter(temp[1:len(temp)]):
		if(m.has_key(i)):
			m.get(i)["actor"][temp[0]] = temp[0]


f2.close()
f3.close()


def intersection(m1, m2):
	count = 0
	for x in m1:
		if m2.has_key(x):
			count = count + 1
	return count

def union(m1, m2):
	u = {}
	for x in m1:
		u[x] = x
	for x in m2:
		u[x] = x
	return len(u)


final = {}
mov = list()

f = open("final2.txt", "w")

for k in m:
	if len(m.get(k)["actor"]) >= 5:
		final[k] = m[k]
		mov.append(k)

t = len(mov)

for i in range(1,t-1):
	print i
	for j in range(i+1,t):
		a1 = m.get(mov[i])["actor"]
		a2 = m.get(mov[j])["actor"]
		w = float(intersection(a1,a2))/union(a1,a2)
		f.write(mov[i]+"	"+mov[j]+"	"+`` + "\n" )
		
	














