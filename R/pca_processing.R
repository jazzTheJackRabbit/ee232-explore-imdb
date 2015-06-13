#Additional processing for PCA
notNanList = which(!is.nan(finalFeatureMatrixForTrainingData[,2]))

filename = paste(filepath,"featureMatrixForTrainingData.txt",sep="")
write.csv(as.matrix(finalFeatureMatrixForTrainingData[notNanList]),filename,row.names = FALSE,col.names=FALSE)

filename = paste(filepath,"ratingForTrainingData.txt",sep="")
write.csv(as.matrix(ratingVectorForTrainingSet[notNanList]),filename,row.names = FALSE,col.names=FALSE)