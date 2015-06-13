filepath = "/Users/amogh/workspace/jazz/ucla/ee232e/project2/code/matlab/storage/"
filename = paste(filepath,"featureMatrixForTrainingData.txt",sep="")
featureMatrix <- as.matrix(read.delim(filename, header = TRUE,sep=","))

filename = paste(filepath,"ratingForTrainingData.txt",sep="")
ratingsVector <- read.delim(filename, header = TRUE,sep="\t")
movieRatingsVector = unlist(ratingsVector,use.names = FALSE)

#Predict for the prediction set
featureMatrixForPredictionData = matrix(, nrow = length(predictionSetVertexIndices), ncol = 3)
for (vertexIndex in 1:length(predictionSetVertexIndices)){    
  #FEATURE1: COMMUNITY AVERAGE RATING
  communityOfMovie = as.numeric(membership(fgcomm)[vertexIndex])
  vertexIndicesInCommunity = which(membership(fgcomm) == communityOfMovie)
  
  #FEATURE2: NEIGHBOR AVERAGE RATING
  neighborVertexIndicesOfCurrentMovie <- neighbors(g3,vertexIndex)
  
  #FEATURE3: AVERAGE FOR NEIGHBOR TOP 20 RATING
  threshold = 20
  if(length(neighborVertexIndicesOfCurrentMovie) > threshold){
    top20NeighborRatingList = sort(V(g3)$rating[neighborVertexIndicesOfCurrentMovie],decreasing = TRUE)[1:threshold]
  }
  else{
    top20NeighborRatingList = sort(V(g3)$rating[neighborVertexIndicesOfCurrentMovie],decreasing = TRUE)[1:length(neighborVertexIndicesOfCurrentMovie)]
  }
  
  #COMPUTE ALL FEATURES
  f1_meanNeighborRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
  f2_meanCommunityRating = mean(V(g2)$ratings[vertexIndicesInCommunity][which(V(g2)$ratings[vertexIndicesInCommunity] > 0)])
  f3_meanTop20NeighborRating = mean(top20NeighborRatingList)
  
  featureVectorForMovie = c(f1_meanNeighborRating,f2_meanCommunityRating,f3_meanTop20NeighborRating)
  featureMatrixForPredictionData[vertexIndex,] = as.numeric(featureVectorForMovie)  
}

f4_meanPageRanks = V(g3)$pageRankForTopActors[predictionSetVertexIndices]
featureMatrixForPredictionData = cbind(featureMatrixForPredictionData,as.numeric(f4_meanPageRanks))

#PCA here

oldFeatureMatrix = featureMatrix
featureMatrix = featureMatrix
pca <- eigen(cov(featureMatrix))
eigenValues <- pca$values
eigenVectors <- pca$vectors

projectionMatrix <- featureMatrix %*% eigenVectors[,1] 

r = movieRatingsVector

pca_f1_fit <- lm(r ~ projectionMatrix)
plot(projectionMatrix,r)
abline(pca_f1_fit)

# y = mx+c -> regression line
m_f1 = pca_f1_fit$coefficients[[2]] 
c_f1 = pca_f1_fit$coefficients[[1]] 

projectedData = featureMatrixForPredictionData %*% eigenVectors[,1] 
predictedRating_f1 = ((projectedData * m_f1) + c_f1)

