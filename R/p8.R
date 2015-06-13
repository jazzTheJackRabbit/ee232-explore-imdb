# part 7
require(igraph)
filepath = "/Users/amogh/workspace/jazz/ucla/ee232e/project2/code/matlab/storage/"

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
V(g2)$pageRankForTopActors <- as.numeric(movieMeanPageRankVector[as.numeric(titleIndices)])

#Hardcode the prediction set names
predictionSetNames = c("894354","779751","763763");
predictionSetVertexIndices = c();
for(i in 1:length(predictionSetNames)){
  indexOfMovieToPredict = which(V(g2)$name == predictionSetNames[i])
  predictionSetVertexIndices = c(predictionSetVertexIndices, indexOfMovieToPredict);
}

#Create a subgraph with the prediction set (only to save all the other attributes, R sucks with OOP!)
g_prediction = induced.subgraph(g2,predictionSetVertexIndices)

#Create a subgraph that contains movies with RATINGS > 0 and GENRE != "n/a" and pageRankScores != -1  [THIS DOES NOT INCLUDE PREDICTION SET]
vertexIndexListOfMoviesWithRating = which(V(g2)$ratings > 0 & V(g2)$pageRankForTopActors != -1)
vertexListOfMoviesWithRating = V(g2)[vertexIndexListOfMoviesWithRating]
g3 = induced.subgraph(g2,vertexIndexListOfMoviesWithRating)

#Create training, testing and prediction set
totalNumberOfMoviesWithRatings = length(V(g3))
trainSetEndIndex = ((1)*totalNumberOfMoviesWithRatings)
trainingVertexIndexList = c(1:trainSetEndIndex)

#PageRankScores:
f1 = V(g3)[trainingVertexIndexList]$pageRankForTopActors

#Create required output rating vector for TRAINING DATA
r = V(g3)[trainingVertexIndexList]$rating

plot(f1,r)
plot(f2,r)

f1_fit <- lm(r ~ f1)

abline(f1_fit)

# y = mx+c -> regression line
m_f1 = f1_fit$coefficients[[2]] 
c_f1 = f1_fit$coefficients[[1]] 

#Predict for the prediction set
featureMatrixForPredictionData = V(g3)$pageRankForTopActors[predictionSetVertexIndices]

predictedRating_f1 = (featureMatrixForPredictionData * m_f1) + c_f1

