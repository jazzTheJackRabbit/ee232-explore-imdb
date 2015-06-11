%TITLES
fileID = fopen('movieTitleVector.txt','w');
fclose(fileID);
fileID = fopen('movieTitleVector.txt','a');
formatSpec = '%s\n';                                                        
for row = 1:length(movieIndexDictionary)    
    movieTitle = movieTitleVector(row);movieTitle = movieTitle{1};   
    
    if(hasSpecialCharacter(movieTitle))
        movieTitle = escapeString(movieTitle);    
    end
    
    output = sprintf(formatSpec,movieTitle);
    fprintf(fileID,output);       
    if(mod(row,1000) == 0)
        disp(row);
    end     
end
fclose(fileID);
