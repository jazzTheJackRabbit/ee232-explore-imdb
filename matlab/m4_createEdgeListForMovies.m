%################################
%Edge list for all actor movies

inputFile = fopen(actor_movies_file);
lineString = fgets(inputFile);
iterIndex = 0;

startTime_actor = fix(clock);

missingMovies = 0;

breakEnabled = 0;
limit = 1000;

movieToMovieLinkMatrix = cell(3000000,1);

fileID = fopen('edgelist.dat','a');

while(lineString ~= -1)
    parsedLineStringArray = strtrim(strsplit(lineString,'\t\t'));
    actorsMovieIndexList = zeros(0,0);    
    for i = 1:size(parsedLineStringArray,2)
        if(i==1)
            actorName = strtrim(parsedLineStringArray(1));actorName = actorName{1};                                    
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
                    actorsMovieIndexList = [actorsMovieIndexList movieIndex];
                end                               
            end         
        end
    end              
    
    %Compute the weight for the edge between each actors movies
    for i = (1:length(actorsMovieIndexList))      
        for j = (i+1:length(actorsMovieIndexList))
            movie_m_index = actorsMovieIndexList(i);
            movie_n_index = actorsMovieIndexList(j);
            if(isempty(find(movieToMovieLinkMatrix{movie_m_index} == movie_n_index, 1)) && isempty(find(movieToMovieLinkMatrix{movie_n_index} == movie_m_index, 1)))
                movie_m_actorList = movieActorsMatrix{movie_m_index};
                movie_n_actorList = movieActorsMatrix{movie_n_index};
                edgeWeight = size(intersect(movie_m_actorList,movie_n_actorList),2)/size(union(movie_m_actorList,movie_n_actorList),2);
                
                if(edgeWeight > 0)     
                    movie_1 = movieTitleVector(movie_m_index);                    
                    movie_2 = movieTitleVector(movie_n_index);        
                    
                    formatSpec = '%s\t%s\t%6.3f\n';                                                        
                    output = sprintf(formatSpec,movie_1{1},movie_2{1},edgeWeight);
                    
                    fprintf(fileID,output);
                    
                    movieToMovieLinkMatrix{movie_m_index} = [movieToMovieLinkMatrix{movie_m_index} movie_n_index];
                end
            end 
        end
    end
    
    lineString = fgets(inputFile);   
    iterIndex = iterIndex + 1;
    
    if(mod(iterIndex,limit) == 0)
        disp(strcat('ACTOR:',int2str(iterIndex),'-',actorName));
    end
    
    if(iterIndex >= limit && breakEnabled)
        break;
    end 
end
fclose(fileID);
endTime_actor = fix(clock);
disp(strcat('Processing done in: ', mat2str(endTime_actor - startTime_actor)))
% disp('Saving workspace to disk,might take some time...');
% save('./matlab_workspace.mat');
