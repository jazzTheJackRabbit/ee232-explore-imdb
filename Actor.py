import numpy as np
import os
from Movie import Movie

class Actor:
    
    #Class variables
    total = 0
    list = []
    hashByName = {}
    actorMovieAdjacencyMatrix = np.zeros((0,Movie.total))
    
    listStorageFile = "./storage/Actor/list.dat"
    totalStorageFile = "./storage/Actor/total.dat"
    hashStorageFile = "./storage/Actor/hash.dat"
    adjacencyMatrixStorageFile = "./storage/Actor/adjacency.dat"
    
    def __init__(self,name):
        self.id = Actor.total
        self.name = name.lower()
        self.movieList = []
               
        Actor.total = Actor.total + 1
        Actor.hashByName[self.name] = self
        
        self.moviesVector = np.zeros((1,Movie.total))
    
    def __str__(self):
        return self.name + " [" + str(self.movieList) + "]"
    
    @staticmethod
    def hasStorageFiles():
        isFile = os.path.isfile
        if(isFile(Actor.listStorageFile) and isFile(Actor.totalStorageFile) and isFile(Actor.hashStorageFile) and isFile(Actor.adjacencyMatrixStorageFile)):
            return True            
        return False
    
    @staticmethod
    def unpickleActors():        
        if(Actor.hasStorageFiles()):
            with open(Actor.listStorageFile,"rb") as actorListStorage:
                Actor.list = pickle.load(actorListStorage)
            with open(Actor.totalStorageFile,"rb") as totalStorage:
                Actor.total = pickle.load(totalStorage)
            with open(Actor.hashStorageFile,"rb") as hashStorage:
                Actor.hashByName = pickle.load(hashStorage)
            with open(Actor.adjacencyMatrixStorageFile,"rb") as adjacencyMatrixStorage:
                Actor.actorMovieAdjacencyMatrix = pickle.load(adjacencyMatrixStorage) 
    
    @staticmethod
    def pickleActors():
        with open(Actor.listStorageFile,"wb") as actorListStorage:
            pickle.dump(Actor.list,actorListStorage)
        with open(Actor.totalStorageFile,"wb") as totalStorage:
            pickle.dump(Actor.total,totalStorage)
        with open(Actor.hashStorageFile,"wb") as hashStorage:
            pickle.dump(Actor.hashByName,hashStorage)
        with open(Actor.adjacencyMatrixStorageFile,"wb") as adjacencyMatrixStorage:
            pickle.dump(Actor.actorMovieAdjacencyMatrix,adjacencyMatrixStorage)