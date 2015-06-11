
# part 5 
datam <- read.csv("mov_gen.txt", sep="\t", header = FALSE)

V(g2)$genre <- as.character(datam[,2])

fgcomm <- fastgreedy.community(g2, weights=E(g2)$V3)

# for each community c 
for(c in 1:length(sizes(fgcomm)))
{
nodes <- which(membership(fgcomm) == c)
print(c)
print(table(V(g2)$genre[nodes])/length(nodes))
print(which(table(V(g2)$genre[nodes])/length(nodes)>0.2))
print("-----------------------------------------------------------------------------")
}

