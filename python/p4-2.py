import numpy as np
import pickle
from Movie import Movie
from Actor import Actor
    
missing_count = 0

def parseMoviesAndGenre():
    Movie.unpickleMovies()
    if(not Movie.total):
        inputFile = open("../dataset/movie_genre.txt")    
        lineString = inputFile.readline()
        
        while(lineString):
            movie_title = lineString.split("\t\t")[0].strip()
            movie_genre = lineString.split("\t\t")[1].strip()
            
            movie = Movie(movie_title,genre=movie_genre)
            
            Movie.list.append(movie)
            
            lineString = inputFile.readline()
            
            if(movie.id%100000 == 0):
                print movie   
        Movie.pickleMovies()
              
        
def parseMoviesAndRatings():
    inputFile = open("../dataset/movie_rating.txt")    
    lineString = inputFile.readline()
    movieRatingVector = np.zeros(0)
    global missing_count
        
    while(lineString):
        (movie_title,movie_year) = Movie.separateTitleAndYear(lineString.split("\t\t")[0].strip())
        movie_rating = float(lineString.split("\t\t")[1].strip())        
        
        if(not movie_title in Movie.hashByTitle):
            movie = Movie(movie_title,rating=movie_rating)
            missing_count = missing_count + 1
        else:    
            movie = Movie.hashByTitle[movie_title]
        
        movie.rating = movie_rating
        
        movieRatingVector = np.append(movieRatingVector,movie_rating)
        
        lineString = inputFile.readline()     
                
        if(movie.id%100000 == 0):
            print movie      
    
    arrayToSave = np.asarray(movieRatingVector)
    np.savetxt("./movie_rating_vector.csv", arrayToSave, delimiter=",")
        
def parseActorsAndMovies():    
    Actor.unpickleActors()
    if(not Actor.total):
        print "Reading all actor data from dataset..."
        inputFile = open("../dataset/actor_movies.txt")
        lineString = inputFile.readline()
        
        while(lineString):
            actor_name = "" 
            parsedLineArray = lineString.split("\t\t")
            
            for i in range(0,len(parsedLineArray)):
                if(i == 0):
                    actor_name = parsedLineArray[0].strip()
                    actor = Actor(actor_name)            
                else:            
                    if(parsedLineArray[i].strip() != ""):
                        (movieTitle,movieYear) = Movie.separateTitleAndYear(parsedLineArray[i].strip())             
                        movieActedIn = Movie.hashByTitle[movieTitle]                
                        #Set actor's movie list
                        actor.movieList.append(movieActedIn)
                        #Update actor's movieVector for current movie
                        actor.moviesVector[0][movieActedIn.id] = 1        
                        #Append current movie's actor list with current actor
                        movieActedIn.actors.append(actor)
            
            lineString = inputFile.readline()
            print actor
            #Append actor's moviesVector to the actorMovieMatrix
            if(Actor.total == 1):
                Actor.actorMovieAdjacencyMatrix = np.append(np.zeros((0,Movie.total)),actor.moviesVector,axis=0)
            else:
                Actor.actorMovieAdjacencyMatrix = np.append(Actor.actorMovieAdjacencyMatrix,actor.moviesVector,axis=0)
        Actor.pickleActors()
    
parseMoviesAndGenre()
# parseMoviesAndRatings()
parseActorsAndMovies()

print missing_count