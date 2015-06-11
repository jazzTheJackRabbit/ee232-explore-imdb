function bool = hasSpecialCharacter(string)
    if(~isempty(find(string == '\')) || ~isempty(find(string == '''')) || ~isempty(find(string == '%')))
        bool = 1;
    else
        bool = 0;
    end    
end
