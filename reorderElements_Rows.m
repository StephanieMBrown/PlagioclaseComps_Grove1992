function [newlyOrderedElements, DLabels, DColors,DLAT,DLONG] = reorderElements_Rows(SpreadsheetName, TabName, targetDataLabel, targetElements,FirstElement,LastElement)

%orderElements('TraceElements', 'Niu2009', Elements)
%reads in data in the wrong order and reorders it 
%%
% 
%  targetDataLabel = 'PlotOn'; 
%  SpreadsheetName = SpreadsheetName; %XLSFileName;
%  TabName= 'UTh_georock'; %'Gakkel'; %char(sheetLabels(i)); 
% % 
% %  targetElements = targetStrings_Trace; 
% % FirstElement = 'FirstTrace';
% % LastElement = 'LastTrace'; 
% % 
% % 
%  targetStrings_Majors = {'Temp','Pressure','SiO2','TiO2','Al2O3', 'Cr2O3','FeO','MnO','MgO','CaO','Na2O','K2O','P2O5','NiO','H2O'};  
%  targetElements = targetStrings_Majors; 
% FirstElement = 'FirstMajor';
% LastElement = 'LastMajor'; 

    

targetElements = upper(targetElements); 



[xlsNumbers, xlsText,xlsRAW] = xlsread(SpreadsheetName, TabName);
[ElementRow,ElementColumn]= find(strcmp(xlsRAW,FirstElement)==1); 
[LastElementRow,LastElementColumn]= find(strcmp(xlsRAW,LastElement)==1); 
Elements = xlsRAW(ElementRow+1, ElementColumn:LastElementColumn); 
Elements = upper(Elements); 
mat2clip(Elements)


%Finds MELTS
xlsRAW_strings=cellfun(@num2str,xlsRAW,'un',0); 
%xlsRAW_strings=upper(xlsRAW_strings); 
[DRow,DColumn]= find(~cellfun(@isempty,regexp(xlsRAW_strings,targetDataLabel)) ==1); 


[LabelRow,LabelColumn]= find(strcmp(xlsRAW_strings,'LABEL')==1); 
[ColorRow,ColorColumn]= find(strcmp(xlsRAW_strings,'COLOR')==1); 
[LATRow,LATColumn]= find(strcmp(xlsRAW_strings,'LAT')==1); 
[LONGRow,LONGColumn]= find(strcmp(xlsRAW_strings,'LONG')==1); 

DLabels = (xlsRAW_strings(unique(DRow),LabelColumn)); 
DColors = xlsRAW_strings(unique(DRow),ColorColumn); 
DLAT= xlsRAW_strings(unique(DRow),LATColumn); 
DLONG = xlsRAW_strings(unique(DRow),LONGColumn); 

[WGPRow,WGPColumn]=find(strcmp(xlsRAW_strings,'Garnet%')==1); 

if isempty(WGPRow)==1
    WGP=[]; 
else 
WGP = cell2mat(xlsRAW(DRow, WGPColumn)); 
end



% test = xlsRAW(DRow,ElementColumn:LastElementColumn);
% % numind = cellfun(@isnumeric, test);
% % test(numind) = {'0'};
% DData = cell2mat(test); 
DData = (xlsRAW(DRow,ElementColumn:LastElementColumn)); 
i1 = cellfun(@ischar,DData);
sz = cellfun('size',DData(~i1),2);

DData(i1) = {nan(1,sz(1))};
DData = cell2mat(DData); 

%this code finds K in ppm and converts 
Kcolumn = find(strcmp('K',Elements)); 
K2Ocolumn = find(strcmp('K2O',Elements)); 
    if any(Kcolumn)&&any(K2Ocolumn)
        Kcolumn_2K2O = DData(:,Kcolumn).*0.83016*10^-4; %converts K in ppm to K2O in wt%
        K2O_Original = DData(:,K2Ocolumn);

        for h = 1:size(K2O_Original,1)
        if isnan(K2O_Original(h))==1
        K2O_Merged(h)=Kcolumn_2K2O(h);
        else
        K2O_Merged(h)=K2O_Original(h);
        end
        end  
        DData(:,K2Ocolumn)=K2O_Merged';
    end
 
 Fe2O3Tcolumn = find(strcmp('FE2O3T',Elements)); 
 Fe2O3column = find(strcmp('FE2O3',Elements)); 
 FeOTcolumn = find(strcmp('FEOT',Elements)); 

 if any(FeOTcolumn)
     FeOTdata = DData(:,FeOTcolumn); 
 end
 
  if any(Fe2O3Tcolumn)
     Fe2O3data = nansum(DData(:,[Fe2O3Tcolumn Fe2O3column]),2);
  else
     Fe2O3data = DData(:,Fe2O3column);
  end

 if any(Fe2O3column)
 FeOcolumn = find(strcmp('FEO',Elements)); 
 FeOTsummedhere=nansum([DData(:,FeOcolumn) 0.899.*Fe2O3data],2);
 end
 
if any(FeOTcolumn) && any(Fe2O3column)
DData(:,FeOcolumn) = max(FeOTdata, FeOTsummedhere); 
else if any(FeOTcolumn)
DData(:,FeOcolumn) = FeOTdata; 
else if any(Fe2O3column)
DData(:,FeOcolumn) =FeOTsummedhere;
end
end
end
 
 
[A,ElementIndicies4Target] = ismember(targetElements, Elements);
noData = find(ElementIndicies4Target==0); 

ElementIndicies4Target(ElementIndicies4Target == 0) = max(ElementIndicies4Target); 

% targetElements
% Elements
% ElementIndicies4Target
% size(DData)
newlyOrderedElements = DData(:,ElementIndicies4Target);

%pads rows of NaNs for elements with missing data
newlyOrderedElements(:,noData)=[NaN]; 





% DataLabels_BC = regexprep(xlsText(unique(Row_BC),Column_BC),'BC_',''); 
% Data_BC = xlsNumbers(ElementRow+1:LastElementRow-1,Column_BC); 
% Colors_BC = xlsText(unique(Row_BC-1),Column_BC);
end

