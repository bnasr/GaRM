function [Tair Tsnow Tdp]=GapTemperature(DOY, Tmean, YR, DR, Phase, RH, Site)
PI=3.1416;
T=Tmean + 0.5 * YR * cos((DOY - Phase)/365*2*PI) + 0.5 * DR * cos(2*PI*DOY -PI/2);
T=T+Site.delTair;

a = 6.1121;
b = 18.678;	
c = 257.14;	 
d = 234.5;
Gamma = log(RH.*exp((b - T/d).*(T./(c + T))));
Tdp = c*Gamma./(b - Gamma)+273.15;

Tair=T+273.15;
Tsnow=min(Tdp,273.15);
%Tsnow=min(Tdp,Tdp);
end