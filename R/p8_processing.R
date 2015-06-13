filename = paste(filepath,"movieActorPageRankMatrix.txt",sep="")
movieActorPageRankTable <- read.table(filename, header = FALSE,sep="\t",blank.lines.skip = FALSE)
movieActorPageRankVector = unlist(movieRatingsTable,use.names = FALSE)


## File
file <- filename

## Create connection
con <- file(description=filename, open="r")

## Hopefully you know the number of lines from some other source or
com <- paste("wc -l ", filename, " | awk '{ print $1 }'", sep="")
n <- system(command=com, intern=TRUE)

movieMeanPageRankVector = c(1:n)
  
## Loop over a file connection
for(i in 1:n) {
  lineString <- toString(scan(file=con, nlines=1, quiet=TRUE,blank.lines.skip = FALSE,sep=","));
  lineString
  stringArray = strsplit(lineString,',')[[1]]  
  if(identical(stringArray,"NA")){
    numericArray = c()
  }else{
    numericArray = as.numeric(stringArray)
  }  
  if(length(numericArray) >= 5){
    sortedArray = sort(numericArray,decreasing = TRUE)
    #TAKE MEAN ONLY OF TOP 5
    meanOfPageRanksForMovie = mean(sortedArray[1:5])
  }else{
    meanOfPageRanksForMovie = -1
  }
  
  movieMeanPageRankVector[i] = meanOfPageRanksForMovie;
  
  if(i%%1000 == 0){
    print(i)
  }
}