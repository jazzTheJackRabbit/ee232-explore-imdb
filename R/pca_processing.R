#Additional processing for PCA

saveMatrix = finalFeatureMatrixForTrainingData;
ratingMatrix = ratingVectorForTrainingSet;
for(i in 1:4){
  notNanList = which(!is.nan(saveMatrix[,i]))  
  saveMatrix = as.matrix(saveMatrix[notNanList,])
  ratingMatrix = as.matrix(ratingMatrix[notNanList])
}

filename = paste(filepath,"featureMatrixForTrainingData.txt",sep="")
write.csv(saveMatrix,filename,row.names = FALSE,col.names=FALSE)

filename = paste(filepath,"ratingForTrainingData.txt",sep="")
write.csv(as.matrix(ratingMatrix),filename,row.names = FALSE,col.names=FALSE)