# part 4 
require(igraph)
filepath = "~/workspace/jazz/ucla/ee232e/project2/data/"
filename = paste(filepath,"edgelist.dat",sep="")
data2 <- read.csv(filename, sep="\t", header=FALSE)
g2 <- graph.data.frame(data2, directed = FALSE)

