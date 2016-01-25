function [mN mL mS Net Lnet Snet rTransect r w vN vLn vSn Sin Lin mSin mLin percBelowOpen R_open S_open L_open OpenAll GapAll]=GapModel_old(H,HeightMap,R,Slope,Aspect,Site,plotoff,SVF)
NoC=20;


%Site=GapForestSite(Project);

dr=R/Site.NR;
dw=2*pi/Site.NW;
dt=10/(24*60);

StephanBoltzman=5.67e-8;

DOYPeriod=(Site.DOY_start:dt:Site.DOY_end);
%[r,w] = meshgrid(dr/2:dr:R-dr/2,0:dw:2*pi);
[r,w] = meshgrid(0:dr:R-dr,0:dw:2*pi);
Area=r.*dr.*dw;
if nargin<8
    %SVF = GapLocalSVF(R,r,w,Slope/180*pi);

    if length(HeightMap)==1
        SVF = GapLocalSVF(R,r,w,Slope/180*pi);
    else
        SVF = GapLocalSVFFromHeightMap(H,HeightMap,R,r,w,Slope/180*pi);
    end
end
if exist([Site.Name '\temperature.txt'],'file') == 2
    [Tair Tsnow]=GapTemperatureFromFile(Site,DOYPeriod);
else
    [Tair Tsnow]=GapTemperature(DOYPeriod',Site.T_m,Site.T_yrange,Site.T_drange,Site.T_phase,Site.RH(mod(ceil(DOYPeriod),365)+1));
end

Sdir=zeros(size(SVF));
Sdif=zeros(size(SVF));

Sdir_open=0;
Sdif_open=0;

for DOY=DOYPeriod;
   Sun=GapSolar(DOY, Slope, Aspect, Site);
   PL=GapPathLength(r,w,(90-Sun.Alpha)/180*pi,Sun.Phi/180*pi,R,Slope/180*pi,Aspect/180*pi);
   if Sun.Alpha>0
       
       Sdir=Sdir+Sun.Sdiropen*exp(-Site.Miu*PL*H);
       Sdif=Sdif+Sun.Sdifopen*SVF;
      %[DOY Sun.Sdifopen Sun.Sdiropen]
       Sdir_open=Sdir_open+Sun.Sdiropen;
       Sdif_open=Sdif_open+Sun.Sdifopen;       
   end
end

Counter=size(DOYPeriod,2);
Sdir=Sdir/Counter;
Sdif=Sdif/Counter;

Sdir_open=Sdir_open/Counter;
Sdif_open=Sdif_open/Counter;

Ssnow=Site.albedo_dir*Sdir+Site.albedo_dif*Sdif;
Ssnow_open=Site.albedo_dir*Sdir_open+Site.albedo_dif*Sdif_open;
%Ssnow=0;
%Snet=Sdir+Sdif-Ssnow;
Snet=(1-Site.albedo_dir)*Sdir./(1-Site.albedo_dir*Site.albedo_canopy*(1-SVF))+(1-Site.albedo_dif)*Sdif./(1-Site.albedo_dif*Site.albedo_canopy*(1-SVF));


distance=zeros(Site.NW+1,Site.NW+1,Site.NR);
Sinc=Sdir(:,Site.NR)+Sdif(:,Site.NR);
dT=2/150*Sinc;
for i=1:Site.NW+1
    distance(i,:,:)=sqrt(r.^2+r(i,Site.NR).^2-2*r.*r(i,Site.NR).*cos(w(i,Site.NR)-w));
end
distance(distance==0)=distance(distance==0)+1e-12;
dTMap=zeros(Site.NW+1,Site.NR);
for i=1:Site.NW+1
    for j=1:Site.NR
        dTMap(i,j)=sum(dT.*1./distance(:,i,j)./sum(1./distance(:,i,j)));
    end
end

Tcan4=(mean(Tair.^4)^.25+dTMap).^4;
%Tcan4=(mean(Tair)+dTMap).^4;
%Tcan4=mean(Tair.^4); 
%Site.eSky=0.7*ones(size(Site.eSky));
Lcan=StephanBoltzman*Site.eCan.*Tcan4.*(1-SVF);
Lsky=StephanBoltzman*mean(Site.eSky(mod(ceil(DOYPeriod'),365)+1).*Tair.^4)*SVF;
Lsnow=StephanBoltzman*Site.eSnow.*mean(Tsnow.^4);
%Lsnow=0;
Lnet=Lcan+Lsky-Lsnow;

Sin=Sdir+Sdif;
Lin=Lcan+Lsky;
Lsky_open=StephanBoltzman*mean(Site.eSky(mod(ceil(DOYPeriod'),365)+1).*Tair.^4);
Lsnow_open=Lsnow;

mLin=MeanVarWeighted(Lin,Area);
mSin=MeanVarWeighted(Sin,Area);

Net=Snet+Lnet;
R_open=Lsky_open-Lsnow_open+Sdir_open+Sdif_open-Ssnow_open;
S_open=Sdir_open+Sdif_open-Ssnow_open;
L_open=Lsky_open-Lsnow_open;
percBelowOpen=sum(sum(Net<R_open))/((Site.NW+1)*Site.NR)*100;
SpercBelowOpen=sum(sum(Snet<S_open))/((Site.NW+1)*Site.NR)*100;
LpercBelowOpen=sum(sum(Lnet<L_open))/((Site.NW+1)*Site.NR)*100;

OpenAll=[Sdir_open Sdif_open ];
GapAll=[MeanVarWeighted(Sdir,Area) MeanVarWeighted(Sdif,Area) ];

w2=mod(w+Aspect/180*pi,2*pi);
North=w2>0.75*pi&w2<1.25*pi;
East =w2>0.25*pi&w2<0.75*pi;
South=w2>1.75*pi|w2<0.25*pi;
West =w2>1.25*pi&w2<1.75*pi;

[mN(1) vN(1)]=MeanVarWeighted(Net,Area);
[mL(1) vLn(1)]=MeanVarWeighted(Lnet,Area);
[mS(1) vSn(1)]=MeanVarWeighted(Snet,Area);

[mN(2) vN(2)]=MeanVarWeighted(Net(North),Area(North));
[mL(2) vLn(2)]=MeanVarWeighted(Lnet(North),Area(North));
[mS(2) vSn(2)]=MeanVarWeighted(Snet(North),Area(North));

[mN(3) vN(3)]=MeanVarWeighted(Net(South),Area(South));
[mL(3) vLn(3)]=MeanVarWeighted(Lnet(South),Area(South));
[mS(3) vSn(3)]=MeanVarWeighted(Snet(South),Area(South));

[mN(4) vN(4)]=MeanVarWeighted(Net(West),Area(West));
[mL(4) vLn(4)]=MeanVarWeighted(Lnet(West),Area(West));
[mS(4) vSn(4)]=MeanVarWeighted(Snet(West),Area(West));

[mN(5) vN(5)]=MeanVarWeighted(Net(East),Area(East));
[mL(5) vLn(5)]=MeanVarWeighted(Lnet(East),Area(East));
[mS(5) vSn(5)]=MeanVarWeighted(Snet(East),Area(East));



%mNetNorth=sum(sum(Net(North).*Area(North)))/sum(sum(Area(North)));
%mNetSouth=sum(sum(Net(South).*Area(South)))/sum(sum(Area(South)));
%mNetWest=sum(sum(Net(West).*Area(West)))/sum(sum(Area(West)));
%mNetEast=sum(sum(Net(East).*Area(East)))/sum(sum(Area(East)));

if plotoff==0
    fontsize=8;
    subplot(3,2,1),ContourPolar(r,w,Snet,['S_N_e_t= ' num2str(mS(1),'%.1f') ' W/m^2 ' ' S_o_p_e_n= ' num2str(S_open,'%.1f') ' W/m^2' ' \DeltaS= ' num2str(mS(1)-S_open,'%.1f') ' W/m^2'],NoC,'auto',Aspect,fontsize);
    subplot(3,2,2),ContourPolar(r,w,Lnet,['L_N_e_t= ' num2str(mL(1),'%.1f') ' W/m^2 ' ' L_o_p_e_n= ' num2str(L_open,'%.1f') ' W/m^2' ' \DeltaL= ' num2str(mL(1)-L_open,'%.1f') ' W/m^2'],NoC,'auto',Aspect,fontsize);
    subplot(3,2,3),ContourPolar(r,w,Net,['Net= ' num2str(mN(1),'%.1f') ' W/m^2 ' ' R_o_p_e_n= ' num2str(R_open,'%.1f') ' W/m^2' ' \DeltaR= ' num2str(mN(1)-R_open,'%.1f') ' W/m^2'],NoC,'auto',Aspect,fontsize);
    subplot(3,2,4),ContourPolar(r,w,Net<R_open,['BelowOpen= ' num2str(percBelowOpen,'%.1f') ' % '],NoC,'auto',Aspect,fontsize);
    subplot(3,2,5),ContourPolar(r,w,Snet<S_open,['Snet BelowOpen= ' num2str(SpercBelowOpen,'%.1f') ' % '],NoC,'auto',Aspect,fontsize);
    subplot(3,2,6),ContourPolar(r,w,Lnet<L_open,['Lnet BelowOpen= ' num2str(LpercBelowOpen,'%.1f') ' % '],NoC,'auto',Aspect,fontsize);
elseif plotoff==3
    subplot(4,2,1),ContourPolar(r,w,Sdir,['Sdir= ' num2str( mean(mean(Sdir)),'%.1f') 'W/m^2' ' \Delta= ' num2str( max(max(Sdir))-min(min(Sdir)),'%.1f') 'W/m^2' ],NoC,'auto',Aspect);
    subplot(4,2,2),ContourPolar(r,w,Sdif,['Sdif= ' num2str( mean(mean(Sdif)),'%.1f') 'W/m^2' ' \Delta= ' num2str( max(max(Sdif))-min(min(Sdif)),'%.1f') 'W/m^2' ],NoC,'auto',Aspect);
%    subplot(4,2,3),ContourPolar(r,w,Ssnow,'Ssnow',NoC,'auto',Aspect);
    subplot(4,2,3),ContourPolar(r,w,Ssnow,['Ssnow= ' num2str( mean(mean(Ssnow)),'%.1f') 'W/m^2' ' \Delta= ' num2str( max(max(Ssnow))-min(min(Ssnow)),'%.1f') 'W/m^2' ],NoC,'auto',Aspect);
    subplot(4,2,4),ContourPolar(r,w,Snet,['S_N_e_t= ' num2str(mS(1),'%.1f') ' W/m^2 ' ' \DeltaS= ' num2str(max(max(Snet))-min(min(Snet)),'%.1f') ' W/m^2'],NoC,'auto',Aspect);
    subplot(4,2,5),ContourPolar(r,w,Lcan,['Lcan= ' num2str( mean(mean(Lcan)),'%.1f') 'W/m^2' ' \Delta= ' num2str( max(max(Lcan))-min(min(Lcan)),'%.1f') 'W/m^2' ],NoC,'auto',Aspect);
    subplot(4,2,6),ContourPolar(r,w,Lsky,['Lsky= ' num2str( mean(mean(Lsky)),'%.1f') 'W/m^2' ' \Delta= ' num2str( max(max(Lsky))-min(min(Lsky)),'%.1f') 'W/m^2' ],NoC,'auto',Aspect);
    subplot(4,2,7),ContourPolar(r,w,Lsnow*ones(size(Lsky)),['Lsnow= ' num2str( mean(mean(Lsnow*ones(size(Lsky)))),'%.1f') 'W/m^2' ' \Delta= ' num2str( max(max(Lsnow*ones(size(Lsky))))-min(min(Lsnow*ones(size(Lsky)))),'%.1f') 'W/m^2' ],NoC,'auto',Aspect);
    subplot(4,2,8),ContourPolar(r,w,Lnet,['Lnet= ' num2str( mean(mean(Lnet)),'%.1f') 'W/m^2' ' \Delta= ' num2str( max(max(Lnet))-min(min(Lnet)),'%.1f') 'W/m^2' ],NoC,'auto',Aspect);
elseif plotoff==2
    %subplot(2,4,[1 2]),
    close
    fontsize=20;
    gcafontsize=fontsize-4;
    set(gcf, 'Position', [50, 50, 800, 650],'PaperPositionMode','auto');
    ContourPolar(r,w,Snet,['S_N_e_t= ' num2str(mS(1),'%.1f') ' W/m^2'],NoC,10*[min(min(floor(Snet/10))) max(max(ceil(Snet/10)))],Aspect,fontsize,1);
    set(gca,'fontsize',gcafontsize);
    print('-dpng',[Site.Name '\SNet-R=' num2str(R,'%.1f') ' Slope=' num2str(Slope,'%.f') ' Aspect=' num2str(Aspect,'%.f') '.png'],'-r600');
    %subplot(2,4,[3 4]),
    close
    set(gcf, 'Position', [50, 50, 800, 650],'PaperPositionMode','auto');
    ContourPolar(r,w,Lnet,['L_N_e_t= ' num2str(mL(1),'%.1f') ' W/m^2'],NoC,10*[min(min(floor(Lnet/10))) max(max(ceil(Lnet/10)))],Aspect,fontsize,1);
    set(gca,'fontsize',gcafontsize);
    print('-dpng',[Site.Name '\LNet-R=' num2str(R,'%.1f') ' Slope=' num2str(Slope,'%.f') ' Aspect=' num2str(Aspect,'%.f') '.png'],'-r600');
    %subplot(2,4,[6 7]),
    close
    set(gcf, 'Position', [50, 50, 800, 650],'PaperPositionMode','auto');
    ContourPolar(r,w,Net,['Net= ' num2str(mN(1),'%.1f') ' W/m^2'],NoC,10*[min(min(floor(Net/10))) max(max(ceil(Net/10)))],Aspect,fontsize,1);
    set(gca,'fontsize',gcafontsize);
    print('-dpng',[Site.Name '\Net R=' num2str(R,'%.1f') ' Slope=' num2str(Slope,'%.f') ' Aspect=' num2str(Aspect,'%.f') '.png'],'-r600');
%     ContourPolar(r,w,Net,['Net= ' num2str(mN(1),'%.1f') ' W/m^2'],NoC,[0 110],Aspect,fontsize);
%     set(gca,'fontsize',gcafontsize);
%     print('-dpng',[Site.Name '\Net-cloudy R=' num2str(R,'%.1f') ' Slope=' num2str(Slope,'%.f') ' Aspect=' num2str(Aspect,'%.f') '.png'],'-r600');
end

rTransect=[-r(1,Site.NR:-1:2) r(ceil(Site.NW/2)+1,:)];

end