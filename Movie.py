import pickle
import os
class Movie:
    
    #Class variables
    total = 0
    list = []
    hashByTitle = {}
    
    listStorageFile = "./storage/Movie/list.dat"
    totalStorageFile = "./storage/Movie/total.dat"
    hashStorageFile = "./storage/Movie/hash.dat"
    
    def __init__(self,title,genre="",rating=-1):
        self.id = Movie.total
        (self.title,self.year) = self.separateTitleAndYear(title)
        self.rating = rating
        self.genre = genre
        self.actors = []        
        
        Movie.total = Movie.total + 1
        Movie.hashByTitle[self.title] = self
    
    def __str__(self):
        return str(self.id) + ":" + self.title
    
    @staticmethod
    def separateTitleAndYear(title):      
        movieTitle = title.split("  ")[0]        
        while(not movieTitle in Movie.hashByTitle):
            title = movieTitle 
            (movieTitle,movieRating) = (title[0:title.rfind("(")].strip().lower(),title[title.rfind("(")-1:title.rfind(")")+1].strip())
            if(title == movieTitle):
                break
        return (movieTitle,movieRating)
    
    @staticmethod
    def hasStorageFiles():
        isFile = os.path.isfile
        if(isFile(Movie.listStorageFile) and isFile(Movie.totalStorageFile) and isFile(Movie.hashStorageFile)):
            return True            
        return False
    
    @staticmethod
    def unpickleMovies():        
        print "unpickling movies..."
        if(Movie.hasStorageFiles()):
            with open(Movie.listStorageFile,"rb") as movieListStorage:
                Movie.list = pickle.load(movieListStorage)
            with open(Movie.totalStorageFile,"rb") as totalStorage:
                Movie.total = pickle.load(totalStorage)
            with open(Movie.hashStorageFile,"rb") as hashStorage:
                Movie.hashByTitle = pickle.load(hashStorage)
        print "done unpickling..."
    
    @staticmethod
    def pickleMovies():
        print "pickling..."
        with open(Movie.listStorageFile,"wb") as movieListStorage:
            pickle.dump(Movie.list,movieListStorage)
        with open(Movie.totalStorageFile,"wb") as totalStorage:
            pickle.dump(Movie.total,totalStorage)
        with open(Movie.hashStorageFile,"wb") as hashStorage:
            pickle.dump(Movie.hashByTitle,hashStorage)
        print "done pickling..."