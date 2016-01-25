function [ SF TAU SVF ]=testGapSVFPathLength(H,D_H,Site,Slope,Aspect,Theta,Phi)
if nargin==0
    H=10;
    D_H=1;
    Site=GapForestSite('C:\Users\ss435\HOME\Manuscripts\ForestGap\Results\Moscow, ID\Moscow, ID-Clear\');
    Slope=0;
    Aspect=0;
    Theta=45;
    Phi=0;
end
if nargin==6
    DOY=Theta;
    Sun=GapSolar(DOY, Slope, Aspect, Site);
    Theta=90-Sun.Alpha;
    Phi=Sun.Phi;
end
%Phi=0;
clf
R=D_H/2;
[r,w] = meshgrid(0:R/100:R-R/100,0:pi/100:(2*pi)+pi/1000000000000);
svf = GapLocalSVF(R,r,w,Slope/180*pi);
pl=GapPathLength(r,w,Theta/180*pi,Phi/180*pi,R,Slope/180*pi,Aspect/180*pi);
pl=pl*H;
%SVF=mean(mean(svf));
[SVF v SVF_std]=MeanVarWeighted(svf(:));
%PL=mean(mean(pl));
[PL v PL_std]=MeanVarWeighted(pl(:));

TAU=mean(mean(exp(-Site.Miu*pl)))*100;
SF=100-mean(mean(exp(-1e6*Site.Miu*pl)))*100;
shadow=exp(-Site.Miu*pl);

subplot(3,1,1), ContourPolar(r,w,svf,['SVF= ' num2str(SVF,'%.2f') ' ' ' \deltaSVF= ' num2str(SVF_std,'%.2f')],20,[0 1],0);
scatter(0,0,'.b');
subplot(3,1,2); ContourPolar(r,w,pl,['PL= ' num2str(PL,'%.2f') ' m ' ' \deltaPL= ' num2str(PL_std,'%.2f') ' m'],20,'auto',Aspect);
scatter(0,0,'.b');
subplot(3,1,3); ContourPolar(r,w,shadow,['SF= '  num2str(SF,'%.f%%') ' ' ' \tau= '  num2str(TAU,'%.f%%')],20,[0 1],Aspect);
scatter(0,0,'.b');
colormap bone
end
