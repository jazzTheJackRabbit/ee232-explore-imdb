# part 7
require(igraph)
filepath = "/Users/amogh/workspace/jazz/ucla/ee232e/project2/code/matlab/storage/"

filename = paste(filepath,"movieRatingsVector.txt",sep="")
movieRatingsTable <- read.delim(filename, header = FALSE,sep="\t")
movieRatingsVector = unlist(movieRatingsTable,use.names = FALSE)

V(g)$rating <- as.numeric(movieRatingsVector[as.numeric(titleIndices)])

vertexListWithGenres = which(V(g)$genre != "n/a")

########################
#DO EVERYTHING TO G2
########################
g2 = induced.subgraph(g,vertexListWithGenres)
titleIndices <- V(g2)$name
V(g2)$ratings <- as.numeric(movieRatingsVector[as.numeric(titleIndices)])

#Hardcode the prediction set names
predictionSetNames = c("894354","779751","763763");
predictionSetVertexIndices = c();
for(i in 1:length(predictionSetNames)){
  indexOfMovieToPredict = which(V(g2)$name == predictionSetNames[i])
  predictionSetVertexIndices = c(predictionSetVertexIndices, indexOfMovieToPredict);
}
#Create a subgraph with the prediction set (only to save all the other attributes, R sucks with OOP!)
g_prediction = induced.subgraph(g2,predictionSetVertexIndices)

#Create a subgraph that contains movies with RATINGS > 0 and GENRE != "n/a" [THIS DOES NOT INCLUDE PREDICTION SET]
vertexIndexListOfMoviesWithRating = which(V(g2)$ratings > 0)
vertexListOfMoviesWithRating = V(g2)[vertexIndexListOfMoviesWithRating]
g3 = induced.subgraph(g2,vertexIndexListOfMoviesWithRating)

#Create training, testing and prediction set
totalNumberOfMoviesWithRatings = length(V(g3))
trainSetEndIndex = round((0.7)*totalNumberOfMoviesWithRatings)
trainingVertexIndexList = c(1:trainSetEndIndex)
testingVertexIndexList = c((trainSetEndIndex+1):totalNumberOfMoviesWithRatings)
trainSetEndIndex;length(trainingVertexList);length(testingVertexList);length(trainingVertexList)+length(testingVertexList)

#Create features for training set
featureMatrixForTrainingData = matrix(, nrow = length(trainingVertexIndexList), ncol = 2)
for (vertexIndex in 1:length(trainingVertexIndexList)){    
  #FEATURE: COMMUNITY AVERAGE RATING
#   communityOfMovie = as.numeric(membership(fgcomm)[vertexIndex])
#   vertexIndicesInCommunity = which(membership(fgcomm) == communityOfMovie)
  
  #FEATURE: NEIGHBOR AVERAGE RATING
  neighborVertexIndicesOfCurrentMovie <- neighbors(g3,vertexIndex)
  
  f1_meanNeighborRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
#   f2_meanCommunityRating = mean(V(g3)$rating[vertexIndicesInCommunity])
  f2_meanCommunityRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
  
  featureVectorForMovie = c(f1_meanNeighborRating,f2_meanCommunityRating)
  featureMatrixForTrainingData[vertexIndex,] = as.numeric(featureVectorForMovie)

  if(vertexIndex%%1000 == 0){
    print(paste(vertexIndex,length(trainingVertexIndexList),sep="/"))
    break
  }
}

#Create required output rating vector for TRAINING DATA
ratingVectorForTrainingSet = V(g3)[trainingVertexIndexList]$rating

#Build the regression model/function here: FIT THE LINE
f1 = as.numeric(featureMatrixForTrainingData[,1])[1:2000]
f2 = as.numeric(featureMatrixForTrainingData[,2])[1:2000]
r = ratingVectorForTrainingSet[1:length(f1)][1:2000]

plot(f1,r)
plot(f2,r)

f1_fit <- lm(r ~ f1)
f2_fit <- lm(r ~ f2)

abline(f1_fit)

# y = mx+c -> regression line
m_f1 = f1_fit$coefficients[[2]] 
c_f1 = f1_fit$coefficients[[1]] 

m_f2 = f2_fit$coefficients[[2]] 
c_f2 = f2_fit$coefficients[[1]]

#Test on the testing set??? [CAN PROBABLY BE IGNORED]
#Create features for training set
featureMatrixForTestingData = matrix(, nrow = length(testingVertexIndexList), ncol = 2)
for (vertexIndex in 1:length(testingVertexIndexList)){    
  #FEATURE: COMMUNITY AVERAGE RATING
  #   communityOfMovie = as.numeric(membership(fgcomm)[vertexIndex])
  #   vertexIndicesInCommunity = which(membership(fgcomm) == communityOfMovie)
  
  #FEATURE: NEIGHBOR AVERAGE RATING
  neighborVertexIndicesOfCurrentMovie <- neighbors(g3,vertexIndex)
  
  f1_meanNeighborRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
  #   f2_meanCommunityRating = mean(V(g3)$rating[vertexIndicesInCommunity])
  f2_meanCommunityRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
  
  featureVectorForMovie = c(f1_meanNeighborRating,f2_meanCommunityRating)
  featureMatrixForTestingData[vertexIndex,] = as.numeric(featureVectorForMovie)
  
  if(vertexIndex%%1000 == 0){
    print(paste(vertexIndex,length(testingVertexIndexList),sep="/"))
    break
  }
}

predictedRatingForTesting_f1 = (featureMatrixForTestingData * m_f1) + c_f1
predictedRatingForTesting_f2 = (featureMatrixForTestingData * m_f2) + c_f2

#Predict for the prediction set
featureMatrixForPredictionData = matrix(, nrow = length(predictionSetVertexIndices), ncol = 2)
for (vertexIndex in 1:length(predictionSetVertexIndices)){    
  #FEATURE: COMMUNITY AVERAGE RATING
  #   communityOfMovie = as.numeric(membership(fgcomm)[vertexIndex])
  #   vertexIndicesInCommunity = which(membership(fgcomm) == communityOfMovie)
  
  #FEATURE: NEIGHBOR AVERAGE RATING
  neighborVertexIndicesOfCurrentMovie <- neighbors(g3,vertexIndex)
  
  f1_meanNeighborRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
  #   f2_meanCommunityRating = mean(V(g3)$rating[vertexIndicesInCommunity])
  f2_meanCommunityRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
  
  featureVectorForMovie = c(f1_meanNeighborRating,f2_meanCommunityRating)
  featureMatrixForPredictionData[vertexIndex,] = as.numeric(featureVectorForMovie)
  
  if(vertexIndex%%1000 == 0){
    print(paste(vertexIndex,length(testingVertexIndexList),sep="/"))
    break
  }
}

predictedRating_f1 = (featureMatrixForPredictionData * m_f1) + c_f1
predictedRating_f2 = (featureMatrixForPredictionData * m_f2) + c_f2
