data <- read.csv("h.csv", sep="\t", header=FALSE)
g <- graph.data.frame(data, directed = TRUE)

pr <- page.rank(g, weights=get.edge.attribute(g, "V3"))$vector
sort(pr, decreasing=TRUE)[1:10]


