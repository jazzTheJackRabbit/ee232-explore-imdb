%Read actor names into matlab.
actorsFromActorNetwork = 'actor_network/ActorsByName.txt';
inputFile = fopen(actorsFromActorNetwork);
lineString = fgets(inputFile);

r_actorIndexDictionary = containers.Map;
r_actorNameVector = cell(242924,1);
lineIndex = 1;
while(lineString ~= -1) 
    currentActorName = lineString; currentActorName = strcat(currentActorName,'');     
    r_actorIndexDictionary(currentActorName) = lineIndex;
    r_actorNameVector{lineIndex} = currentActorName;
    
    if(mod(lineIndex,1000)==0)
        disp(strcat(int2str(lineIndex),':',currentActorName));
    end
    
    lineIndex = lineIndex + 1;
    lineString = fgets(inputFile);    
end
fclose(inputFile);