# part 5 
require(igraph)
filepath = "/Users/amogh/workspace/jazz/ucla/ee232e/project2/code/matlab/storage/"

filename = paste(filepath,"movieGenreVector.txt",sep="")
movieGenreTable <- read.table(filename, header = FALSE, flush = TRUE,sep="\t")

filename = paste(filepath,"movieTitleVector.txt",sep="")
movieTitleTable <- read.delim(filename, header = FALSE,sep="\t")

filename = paste(filepath,"movieRatingsVector.txt",sep="")
movieRatingsTable <- read.delim(filename, header = FALSE,sep="\t")

movieTitleVector = unlist(movieTitleTable,use.names = FALSE)
movieGenreVector = unlist(movieGenreTable,use.names = FALSE)
movieRatingsVector = unlist(movieRatingsTable,use.names = FALSE)

#PART 5 STARTS HERE
filename = paste(filepath,"edgelist.dat",sep="")
data2 <- read.csv(filename, sep="", header=FALSE)

g=graph.data.frame(as.matrix(data2),directed=FALSE)

titleIndices <- V(g)$name
V(g)$title <- as.character(movieTitleVector[as.numeric(titleIndices)])
V(g)$genre <- as.character(movieGenreVector[as.numeric(titleIndices)])
V(g)$ratings <- as.numeric(movieRatingsVector[as.numeric(titleIndices)])

vertexListWithGenres = which(V(g)$genre != "n/a")

g2 = induced.subgraph(g,vertexListWithGenres)

startTime_communityCreation = timestamp()
fgcomm <- fastgreedy.community(g2, weights=E(g2)$V3)
endTime_communityCreation = timestamp()
sendMail('[232 Script Update]','Community Detection is Done!')


# for each community c 
for(c in 1:length(sizes(fgcomm)))
{
  nodes <- which(membership(fgcomm) == c)
  print(c)
  print(table(V(g2)$genre[nodes])/length(nodes))
  print(which(table(V(g2)$genre[nodes])/length(nodes)>0.2))
  print("-----------------------------------------------------------------------------")
}


sendMail <- function(titleText,bodyText){
  library(mailR)
  sender <- "roycee232@gmail.com"
  recipients <- c("amogh.91@gmail.com")
  send.mail(from = sender,
            to = recipients,
            subject = titleText,
            body = bodyText,
            smtp = list(host.name = "smtp.gmail.com", port = 465, 
                        user.name="roycee232@gmail.com", passwd="royc1234", ssl=TRUE),
            authenticate = TRUE,
            send = TRUE)
}
