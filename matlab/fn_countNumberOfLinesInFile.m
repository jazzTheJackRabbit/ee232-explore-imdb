function [numberOfLines] = fn_countNumberOfLinesInFile(filename)
    numberOfLines = 0
    file = fopen(filename)
    lineString = fgets(file)
    while(lineString ~= -1)
        numberOfLines = numberOfLines + 1;
        lineString = fgets(file);      
        if(mod(numberOfLines,1000) == 0)
            disp(numberOfLines)
        end
    end
end