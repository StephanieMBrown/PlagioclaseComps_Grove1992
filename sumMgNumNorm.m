function [probeData,NewElementOrder] = sumMgNumNorm(probeData,ElementOrder)
targetElements = upper(ElementOrder); 
% adds on columns:

% total 
% Mg # 
% NaK #
% CaO/Al2O3
% new column headings 
NewColumnHeadings = {'Total','Mg#','NaK#','CaO/Al2O3','An'};

MgOcolumn = find(strcmp('MGO',targetElements)); 
FeOcolumn = find(strcmp('FEO',targetElements)); 
CaOcolumn = find(strcmp('CAO',targetElements)); 
Na2Ocolumn = find(strcmp('NA2O',targetElements)); 
K2Ocolumn = find(strcmp('K2O',targetElements)); 
Al2O3column = find(strcmp('AL2O3',targetElements)); 

datarange = [1:size(ElementOrder,2)];
    
    %normalizes by each row
    for n=1:size(probeData,1)
        probeData(n,datarange) = 100*probeData(n,datarange)./nansum(probeData(n,datarange));
    end

    probeData(:,max(datarange)+1) = nansum(probeData(:,datarange),2); %%recalculates total

    %calculates the Mg#
    probeData(:,max(datarange)+2) = (probeData(:,MgOcolumn)./40.311)./((probeData(:,MgOcolumn)./40.311) + (probeData(:,FeOcolumn)./71.846));
    
    %NaK#
    probeData(:,max(datarange)+3) =  nansum(probeData(:,[Na2Ocolumn K2Ocolumn]),2)./nansum(probeData(:,[CaOcolumn Na2Ocolumn K2Ocolumn]),2);
    
    %CaO Al2O3 ratio
    probeData(:,max(datarange)+4) =  probeData(:,CaOcolumn)./probeData(:,Al2O3column);
    
    %An content
    CaMoles = probeData(:,CaOcolumn)./56.078; 
    KMoles = probeData(:,K2Ocolumn )./94.196.*2; 
    NaMoles =  probeData(:,Na2Ocolumn )./61.979.*2; 
    probeData(:,max(datarange)+5) =  CaMoles./(CaMoles+KMoles+NaMoles);
    
    
    NewElementOrder=cat(2,ElementOrder,NewColumnHeadings);
    


end



