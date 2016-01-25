function GapShadowOnGap(DOY,R,Slope,Aspect,Site,figlabel)
if nargin==5
    figlabel='';
end

[r,w] = meshgrid(0:R/Site.NR:R-R/Site.NR,0:2*pi/Site.NW:(2*pi));

Sun=GapSolar(DOY, Slope, Aspect, Site);
Shadow=exp(-Site.Miu*GapPathLength(r,w,Sun.Theta/180*pi,Sun.Phi/180*pi,R,Slope/180*pi,Aspect/180*pi));
%ShadedArea=sum(sum((Shadow~=1).*r*R/NR*2*pi/Nw))/(pi*R^2);
ShadedArea=sum(sum((Shadow~=1).*r))/sum(sum((ones(size(Shadow))).*r));
fontsize=12;

%ContourPolar(r,w,Shadow,['Shadow =' num2str(ShadedArea*100,'%%%.1f at:') ' ' datestr(DOY+734868)],1000,'auto');
title=['SF:' num2str(ShadedArea*100,'%.f%%') '   \theta:' num2str(Sun.Theta,' %.f') char(176) '   \phi:' num2str(Sun.Phi,' %.f') char(176)];
date=datestr(DOY+734868);
date=[date(1:6),date(12:17)];
ContourPolar(r,w,Shadow,{title ;date},20,'auto',Aspect,fontsize);

text(-0.9*R,-0.9*R,figlabel,'fontweight','b','fontsize',fontsize);
colormap gray
colorbar off
%print('-dpng',['Shadow, DOY=' num2str(DOY) 'R=' num2str(R,'%.1f') ' Slope=' num2str(Slope,'%.f') ' Aspect=' num2str(Aspect,'%.f') '.png'],'-r300');

end