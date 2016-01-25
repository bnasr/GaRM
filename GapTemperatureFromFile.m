function [Tair Tsnow]=GapTemperatureFromFile(Site,DOYPeriod)
Temperature=load([Site.Name '\temperature.txt']);
T=interp1(Temperature(:,1),Temperature(:,2),DOYPeriod);

T=T+Site.delTair;

a = 6.1121;
b = 18.678;	
c = 257.14;	 
d = 234.5;
Gamma = log(Site.RH.*exp((b - T/d).*(T./(c + T))));
Tdp = c*Gamma./(b - Gamma);

Tair=T+273.15;
Tsnow=min(Tdp,0)+273.15;
end
