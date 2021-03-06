# part 7
require(igraph)
filepath = "C:/Users/Administrator/ws/ee232/explore_imdb/matlab/storage/"

filename = paste(filepath,"movieRatingsVector.txt",sep="")
movieRatingsTable <- read.delim(filename, header = FALSE,sep="\t")
movieRatingsVector = unlist(movieRatingsTable,use.names = FALSE)

V(g)$rating <- as.numeric(movieRatingsVector[as.numeric(titleIndices)])

########################
#DO EVERYTHING TO G2
########################

titleIndices <- V(g2)$name
V(g2)$ratings <- as.numeric(movieRatingsVector[as.numeric(titleIndices)])
V(g2)$rating <- as.numeric(movieRatingsVector[as.numeric(titleIndices)])
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
trainSetEndIndex = ((1)*totalNumberOfMoviesWithRatings)
trainingVertexIndexList = c(1:trainSetEndIndex)
testingVertexIndexList = c((trainSetEndIndex+1):totalNumberOfMoviesWithRatings)
testingVertexIndexList = c()
trainSetEndIndex;length(trainingVertexIndexList);length(testingVertexIndexList);length(trainingVertexIndexList)+length(testingVertexIndexList)

#Create features for training set
featureMatrixForTrainingData = matrix(, nrow = length(trainingVertexIndexList), ncol =3)
for (vertexIndex in 1:length(trainingVertexIndexList)){    
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
  featureMatrixForTrainingData[vertexIndex,] = as.numeric(featureVectorForMovie)

  if(vertexIndex%%1000 == 0){
    print(paste(vertexIndex,length(trainingVertexIndexList),sep="/"))
  }
}

#Create required output rating vector for TRAINING DATA
ratingVectorForTrainingSet = V(g3)[trainingVertexIndexList]$rating

#Build the regression model/function here: FIT THE LINE
f1 = as.numeric(featureMatrixForTrainingData[,1])
f2 = as.numeric(featureMatrixForTrainingData[,2])
f3 = as.numeric(featureMatrixForTrainingData[,3])
r = ratingVectorForTrainingSet[1:length(f1)]

plot(f1,r)
plot(f2,r)

f1_fit <- lm(r ~ f1)
f2_fit <- lm(r ~ f2)
f3_fit <- lm(r ~ f3)

abline(f1_fit)

# y = mx+c -> regression line
m_f1 = f1_fit$coefficients[[2]] 
c_f1 = f1_fit$coefficients[[1]] 

m_f2 = f2_fit$coefficients[[2]] 
c_f2 = f2_fit$coefficients[[1]]

m_f3 = f3_fit$coefficients[[2]] 
c_f3 = f3_fit$coefficients[[1]]

########################
######IGNORE-START######
########################
#Test on the testing set??? [CAN PROBABLY BE IGNORED]
#Create features for training set
# featureMatrixForTestingData = matrix(, nrow = length(testingVertexIndexList), ncol = 2)
# for (vertexIndex in 1:length(testingVertexIndexList)){    
#   #FEATURE: COMMUNITY AVERAGE RATING
#   #   communityOfMovie = as.numeric(membership(fgcomm)[vertexIndex])
#   #   vertexIndicesInCommunity = which(membership(fgcomm) == communityOfMovie)
#   
#   #FEATURE: NEIGHBOR AVERAGE RATING
#   neighborVertexIndicesOfCurrentMovie <- neighbors(g3,vertexIndex)
#   
#   f1_meanNeighborRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
#   #   f2_meanCommunityRating = mean(V(g3)$rating[vertexIndicesInCommunity])
#   f2_meanCommunityRating = mean(V(g3)$rating[neighborVertexIndicesOfCurrentMovie])  
#   
#   featureVectorForMovie = c(f1_meanNeighborRating,f2_meanCommunityRating)
#   featureMatrixForTestingData[vertexIndex,] = as.numeric(featureVectorForMovie)
#   
#   if(vertexIndex%%1000 == 0){
#     print(paste(vertexIndex,length(testingVertexIndexList),sep="/"))
#     break
#   }
# }
# 
# predictedRatingForTesting_f1 = (featureMatrixForTestingData * m_f1) + c_f1
# predictedRatingForTesting_f2 = (featureMatrixForTestingData * m_f2) + c_f2
######################
######IGNORE-END######
######################

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

predictedRating_f1 = (featureMatrixForPredictionData[,1] * m_f1) + c_f1
predictedRating_f2 = (featureMatrixForPredictionData[,2] * m_f2) + c_f2
predictedRating_f3 = (featureMatrixForPredictionData[,3] * m_f3) + c_f3
