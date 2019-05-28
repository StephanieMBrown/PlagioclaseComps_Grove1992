
 function [AN_content] = PlagComp_Grove1992(inputData,P,inputElementOrder)
% This function was rewritten from the function "OPAMPL" used in 
% Yang et al. 1996 and Grove et al. 1992


% DAT array used here:
% 1-SIO2 2-TIO2 3-AL2O3 4-FE2O3 5-FEO 
% 6-MGO 7-CAO 8-NA2O 9-K2O 
% 10-P2O5 11-CR2O3 12-MNO;
ElementOrderHere = {'SiO2','TiO2','Al2O3','Fe2O3','FeO','MgO','CaO','Na2O','K2O','P2O5','Cr2O3','MnO'};
   

clear data2reorder ReorderedData
data2reorder = inputData;
[A,ElementIndicies4Target] = ismember(ElementOrderHere, inputElementOrder);
nodata = find(ElementIndicies4Target==0); 
ElementIndicies4Target(ElementIndicies4Target == 0) = max(ElementIndicies4Target); 
ReorderedData = data2reorder(:,ElementIndicies4Target);
%pads rows of NaNs for elements with missing data
ReorderedData(:,nodata)=[NaN]; 
DAT = ReorderedData; 


% DIMENSION DAT(51,12)
% REAL DAT(51,12),MSIO2,MKALO2,MNAALO2,MCAAL2O4,MCAO,MMGO,MFEO
% REAL MTIO2,MPO25,SUM,SUM1,A,MPLAN,MPLAB
% REAL MPLCAO,MPLNA2O,MPLAL2O3,MPLSIO2,PLCAO,PLNA2O,PLSIO2,PLAL2O3


MSIO2   = DAT(:,1)./60.09;
MKALO2  = DAT(:,9)./94.2*2;
MNAALO2 = DAT(:,8)./62*2;
MCAAL2O4= (DAT(:,3)./102*2-MKALO2-MNAALO2)./2;
MCAO = DAT(:,7)./56-MCAAL2O4;
MMGO=DAT(:,6)./40.3;
MFEO=DAT(:,5)./71.85;
MTIO2=DAT(:,2)./79.9;
MPO25=DAT(:,10)./141.9*2;


SUM=nansum([MSIO2,MKALO2,MNAALO2,MCAAL2O4,MCAO,MMGO,MFEO,MTIO2,MPO25],2);

MSIO2=MSIO2./SUM;
MKALO2=MKALO2./SUM;
MNAALO2=MNAALO2./SUM;
MCAAL2O4=MCAAL2O4./SUM;

A=MCAAL2O4./(MNAALO2.*MSIO2).*exp(11.1068-0.0338.*P-4.4719.* ...
    (1-MNAALO2).*(1-MNAALO2)-6.9707.*(1-MKALO2).*(1-MKALO2));


MPLAN=A./(1+A);
AN_content = MPLAN;


% code for calcuating plagioclase composition
% email me (brownsm@mit.edu) for help if you want to use this
% MPLAB=1-MPLAN;
% MPLCAO=MPLAN;
% MPLNA2O=MPLAB./2;
% 
% MPLAL2O3=(2*MPLAN+MPLAB)./2;
% MPLSIO2=2*MPLAN+3*MPLAB;
% PLCAO=MPLCAO*56.08;
% PLNA2O=MPLNA2O*62;
% PLAL2O3=MPLAL2O3*102;
% PLSIO2=MPLSIO2*60.09;
% SUM1=PLCAO+PLNA2O+PLSIO2+PLAL2O3;
% 
% PLCAO=PLCAO./SUM1*100;
% PLNA2O=PLNA2O./SUM1*100;
% PLAL2O3=PLAL2O3./SUM1*100;
% PLSIO2=PLSIO2./SUM1*100;



end
