%########################
%Parse movies and ratings

inputFile = fopen(movie_rating_file);
lineString = fgets(inputFile);

iterIndex = 0;

startTime = fix(clock);
breakEnabled = 0;
limit = 10000;

while(lineString ~= -1)
    parsedLineStringArray = strtrim(strsplit(lineString,'\t\t'));
    
    movieTitle = strtrim(parsedLineStringArray(1));movieTitle = movieTitle{1};        
    movieRating = strtrim(parsedLineStringArray(2));movieRating = str2double(movieRating{1}); 
                
    if(~isKey(movieIndexDictionary,movieTitle))
        movieIndexDictionary(movieTitle) = movieIndexMax;  
        movieTitleVector{movieIndexMax} = movieTitle;
        movieRatingVector(movieIndexMax) = movieRating;        
        movieIndexMax = movieIndexMax + 1;        
    else
        movieIndex = movieIndexDictionary(movieTitle);
        movieRatingVector(movieIndex) = movieRating;
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
