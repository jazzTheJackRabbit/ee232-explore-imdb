%Read page rank scores into matlab.
pageRankScoresFromActorNetwork = 'actor_network/SortedPageRank.txt';
inputFile = fopen(pageRankScoresFromActorNetwork);
lineString = fgets(inputFile);

r_ActorPageRankVector = cell(242924,1);
lineIndex = 1;
while(lineString ~= -1) 
    currentActorPageRank = lineString; 
    currentActorPageRank = str2double(currentActorPageRank);
    r_ActorPageRankVector{lineIndex} = currentActorPageRank;
    
    if(mod(lineIndex,1000)==0)
        disp(strcat(int2str(lineIndex),':', num2str(currentActorPageRank)));
    end
    
    lineIndex = lineIndex + 1;
    lineString = fgets(inputFile);    
end