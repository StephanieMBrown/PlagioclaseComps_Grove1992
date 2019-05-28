% May 28 2019 written by brownsm
% This code reads in liquid compositions from a user-tagged generic spreadsheet, and
% calulates equilibrium plagioclase compositions. Results are automatically clipped to the clipboard

close all
clear all
% Steps for you to do:
    %1. Paste here the name of your spreadsheet'
    SpreadsheetName= 'Step1_TagThisMasterSpreadsheet';
    
    %2. Paste here the name of the worksheet in the spreadsheet with the data
    %If you have more than 1 tab, there is a version of this code that will
    %run through each tab and do the calculations
    
    % Instructions to tag the spreadsheet: 
%         1. In the row above your labeled data denote where the major elements start and stop and the data label as shown in the example
%         2. Specify each liquid comp you wish to calulate by typing "UseData" in the "Use?" column as shown in the example
    TabName = {'InputData'}; 
    
    %3. Specify your desired element order, can be the same as the spreadsheet
    % or different as is given in the default e.g.,:
    %DesiredElementOrder = {'SiO2','TiO2','Al2O3','Cr2O3','FeO','MnO','MgO','CaO','Na2O','K2O','P2O5','NiO','H2O'}; 
    DesiredElementOrder = {'SiO2','TiO2','Al2O3','Cr2O3','FeO','MnO','MgO','CaO','Na2O','K2O'};
    
    %4. Specify pressures of equilibration
    P=[0.001 1 3 4 5]; %in kilobars
    
    %5. run the code and simply paste the results in your spreadsheet
        %(which are automatically saved to the clipboard)
        %By default, the code pastes reformatted data with An calculations
        %Can change to only paste An results, see lines 77+
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculations
i=1;
%Import data : this script is infinitely adaptable 

    %   reorder the data
    %	convert Fe2O3 to FeOtotal
    %	does NOT renormalize the data

    [MajorElements, Major_Labels] = ...
        reorderElements_Rows(SpreadsheetName, TabName{i}, 'UseData', DesiredElementOrder,'FirstMajor','LastMajor'); 

    %  normalize the data and calculate various compositional parameters:
    %   new headings saved as DesiredElementOrder_Normalized)
    [MajorElements_Normalized,DesiredElementOrder_Normalized]=sumMgNumNorm(MajorElements,DesiredElementOrder);
    
%Calculate An content   
    for i = 1:size(P,2)
        [AN_content(:,i)] = PlagComp_Grove1992(MajorElements_Normalized,P(i),DesiredElementOrder_Normalized);
        newheadings{i}=sprintf('X An %s kbars',num2str(P(i)));
    end
    
  %Append to reordered Data 
    MajorElements_Normalized_AN=[MajorElements_Normalized AN_content];
    DesiredElementOrder_Normalized_AN=cat(2,DesiredElementOrder_Normalized,newheadings);
    
    %Append labels
    Labels=cat(1,'Labels',Major_Labels);
    
  
  %Makes a new cell array and copies to the clipboard
  Output2Paste = num2cell(MajorElements_Normalized_AN);
  Output2Paste=cat(1,DesiredElementOrder_Normalized_AN,Output2Paste);
  Output2Paste=cat(2,Labels,Output2Paste);
  
  mat2clip(Output2Paste)
  'Done -- ready to paste'
 
  %If you prefer to just paste the An contents, uncomment this code and
  %use instead of lines 70-72:
%   Output2Paste = num2cell(AN_content);
%   Output2Paste=cat(1,newheadings,Output2Paste);
%   mat2clip(Output2Paste)
%   'Done -- ready to paste'