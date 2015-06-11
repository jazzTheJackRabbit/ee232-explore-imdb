%########################
%Parse actresses and movies

inputFile = fopen(actress_movies_file);
lineString = fgets(inputFile);

startTime = fix(clock);
actress_iter_index = 0;

breakEnabled = 0;
limit = 10000;

while(lineString ~= -1)
    parsedLineStringArray = strtrim(strsplit(lineString,'\t\t')); 
    for i = 1:size(parsedLineStringArray,2)
        if(i==1)
            actorName = strtrim(parsedLineStringArray(1));actorName = actorName{1};                        
            actorIndexDictionary(actorName) = actorIndexMax;
            actorNameVector{actorIndexMax} = actorName;
            actorIndexMax = actorIndexMax + 1;
        else            
            movieTitle = strtrim(parsedLineStringArray(i));movieTitle = movieTitle{1};                  
            if(~isequal(movieTitle,''))                
                while(~isKey(movieIndexDictionary,movieTitle))                                            
                    s = strfind(movieTitle, '('); 
                    e = strfind(movieTitle, ')'); 
                    if(size(s,2) > 1)
                        %movieTitle has multiple brackets                        
                        s = s(length(s));  
                        e = e(length(e));
                        movieTitle = strtrim(movieTitle(1:s-1));
                    else                        
                        %ignore the movie
                        break;                        
                    end                                            
                end    
                if(isKey(movieIndexDictionary,movieTitle))
                    movieIndex = movieIndexDictionary(movieTitle);
                    actorID = actorIndexMax-1;
                    movieActorsMatrix{movieIndex} = [movieActorsMatrix{movieIndex} actorID];
                    totalActorsForMovie(movieIndex) = totalActorsForMovie(movieIndex) + 1;
                    actorsMovieList = [actorsMovieList movieIndex];
                end               
                %For each movie add the actor to it's actor list file
            end         
        end
    end              
            
    lineString = fgets(inputFile);   
    iterIndex = iterIndex + 1;
    actress_iter_index = actress_iter_index  + 1;
    
    if(mod(iterIndex,limit) == 0)
        disp(strcat(int2str(iterIndex),'-',actorName));
    end
    
    if(iterIndex >= limit && breakEnabled)
        break;
    end 
end

endtime = fix(clock);
save('./matlab_workspace.mat');
