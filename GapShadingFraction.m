function [SF TAU TAUNormal]=GapShadingFraction(H,R,Slope,Aspect,Site,DOY)
%[r,w] = meshgrid(dr/2:dr:R-dr/2,0:dw:2*pi);
dr=R/Site.NR;
dw=2*pi/Site.NW;

[r,w] = meshgrid(0:dr:R-dr,0:dw:2*pi);

Sun=GapSolar(DOY, Slope, Aspect, Site);
PL=GapPathLength(r,w,(90-Sun.Alpha)/180*pi,Sun.Phi/180*pi,R,Slope/180*pi,Aspect/180*pi);

TAU=mean(mean(exp(-H*Site.Miu*PL)))*100;
TAUNormal=mean(mean(exp(-H*Site.Miu*PL)*cosd(Sun.Theta)))*100;
SF=100-mean(mean(exp(-H*1e6*Site.Miu*PL)))*100;
end