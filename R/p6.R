#The 3 movies that we target
targetVertices = c(1,2,3)

for(i in 1:length(targetVertices)){
  neighborsOfVertex = neighborhood(g,targetVertcies[i],1)  
  edgePairMatrix = rbind(rep(targetVertices[i],length(neighborsOfVertex)),neighborsOfVertex)
  edgeIndices = get.edge.ids(g,edgePairMatrix)
  edgeWeights = E(g)$weight[edgeIndices]  
  sortedEdgeWeights = sort.int(edgeWeights,index.return=TRUE,decreasing = TRUE)[1:5]
  sortedNeighborIndices = sort.int(edgeWeights,index.return=TRUE,decreasing = TRUE)$ix[1:5]
  V(g)$title[neighborsOfVertex[sortedNeighborIndices]]
  V(g)$genre[neighborsOfVertex[sortedNeighborIndices]]
  membership(fgcomm)[neighborsOfVertex[sortedNeighborIndices]]
}
  