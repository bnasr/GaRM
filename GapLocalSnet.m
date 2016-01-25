function [Snet Sdir Sdif Ssnow]=GapLocalSnet(R,Slope,Aspect,DOYPeriod,r,w,Site)
if nargin==6
    Site=Greenville;
end
AlbedoDir=0.4;
AlbedoDif=0.8;
Miu=0.1;

Sdir=0;
Sdif=0;
SVF = GapLocalSVF(R,r,w,Slope/180*pi);

for DOY=DOYPeriod;
   Sun=GapSolar(DOY, Slope, Aspect, Site);
   PL=GapPathLength(r,w,Sun.Theta/180*pi,Sun.Phi/180*pi,R,Slope/180*pi,Aspect/180*pi);
   if Sun.Alpha>0
       Sdir=Sdir+Sun.Sdiropen*exp(-Miu*PL);
       Sdif=Sdif+Sun.Sdifopen*SVF;
   end
end

Counter=size(DOYPeriod,2);
Sdir=Sdir/Counter;
Sdif=Sdif/Counter;

Ssnow=AlbedoDir*Sdir+AlbedoDif*Sdif;
Snet=Sdir+Sdif-Ssnow;
end
