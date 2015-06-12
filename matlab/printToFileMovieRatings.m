%TITLES
fileID = fopen('movieRatingsVector.txt','w');
fclose(fileID);
fileID = fopen('movieRatingsVector.txt','a');
formatSpec = '%2.2f\n';                                                        
for row = 1:length(movieIndexDictionary)       
    movieRating = movieRatingVector(row);
   
    output = sprintf(formatSpec,movieRating);
    fprintf(fileID,output);       
    if(mod(row,1000) == 0)
        disp(row);
    end     
end
fclose(fileID);