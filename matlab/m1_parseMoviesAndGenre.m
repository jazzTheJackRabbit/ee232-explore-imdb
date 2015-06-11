dir_name = '../../dataset/';
movie_genre_file = strcat(dir_name,'movie_genre.txt');
movie_rating_file = strcat(dir_name,'movie_rating.txt');
actor_movies_file = strcat(dir_name,'actor_movies.txt');
actress_movies_file = strcat(dir_name,'actress_movies.txt');
director_movies_files = strcat(dir_name,'director_movies.txt');

%########################
%Parse movies and genres - 1010991 movies

inputFile = fopen(movie_genre_file);
lineString = fgets(inputFile);
movieIndexDictionary = containers.Map;
genreIndexDictionary = containers.Map;

movieIndexMax = 1;
genreIndexMax = 1;

movieTitleVector = cell(3000000,1);
movieRatingVector = zeros(3000000,1);
movieGenreVector = zeros(3000000,1);

breakEnabled = 0;
limit = 10000;

iterIndex = 0;

startTime = fix(clock);

while(lineString ~= -1)
    parsedLineStringArray = strtrim(strsplit(lineString,'\t\t'));
    
    movieTitle = strtrim(parsedLineStringArray(1));movieTitle = movieTitle{1};        
    movieGenre = strtrim(parsedLineStringArray(2));movieGenre = movieGenre{1}; 
                
    if(~isKey(movieIndexDictionary,movieTitle))
        movieIndexDictionary(movieTitle) = movieIndexMax;        
        movieTitleVector{movieIndexMax} = movieTitle;
        movieIndexMax = movieIndexMax + 1;   
    end
    
    if(~isKey(genreIndexDictionary,movieGenre))
        genreIndexDictionary(movieGenre) = genreIndexMax;        
        movieGenreVector(movieIndexMax - 1) = genreIndexMax;
        genreIndexMax = genreIndexMax + 1;
    else
        genreIndex = genreIndexDictionary(movieGenre);
        movieGenreVector(movieIndexMax - 1) = genreIndex;
    end            
        
    lineString = fgets(inputFile);   
    
    iterIndex = iterIndex + 1;
    if(mod(iterIndex,limit) == 0)
        disp(strcat(int2str(iterIndex),'-',movieTitle))
    end
    if(iterIndex >= limit && breakEnabled)
        break;
    end 
end

endtime = fix(clock);
save('./matlab_workspace.mat');

