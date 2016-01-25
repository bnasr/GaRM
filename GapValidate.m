function GapValidate
Project='.';

Site=GapForestSite(Project);
Site.eSky=Site.eSky*ones(1,365);
Site.eCLD=Site.eCLD*ones(1,365);
Site.eCLR=Site.eCLR*ones(1,365);
Site.tDIR=Site.tDIR*ones(1,365);
Site.tDIF=Site.tDIF*ones(1,365);
Site.SKYCOVER=Site.SKYCOVER*ones(1,365);
Sin_t=load('Sin_South_North_withTimeFeb18.txt');
Lin_t=load('Lin_South_North_withTimeFeb18.txt');
Lin_x=load('Lin_midnightFeb18_withPosition.txt');
Sin_x=load('Sin_noonFeb18_withPosition.txt');
tmpSite=Site;
H=25;
D=60;
R=D/2/H;
[ Height Theta]=TreeHeightFromSkyMap('SVF.png',D,1000,0.1,1);

nTime=48;
dTime=1.0/nTime;

SinTable=zeros(nTime,2*Site.NR);
LinTable=SinTable;
HeightMap=[Theta Height];
%HeightMap=0;
for i=0:nTime
    tmpSite.DOY_start=Site.DOY_start+i*dTime;
    tmpSite.DOY_end=tmpSite.DOY_start+0;
    [Sin Lin]=GapValidateTransect(tmpSite,H,HeightMap,R,0, 0);
    SinTable(i+1,:)=Sin;
    LinTable(i+1,:)=Lin;
    Time(i+1)=i/nTime*24;
    i/nTime
end

save results

tmpSite.DOY_start=Site.DOY_start+12.5/24.;
tmpSite.DOY_end=tmpSite.DOY_start+0;
[Sin_noon Lin_noon]=GapValidateTransect(tmpSite,H,HeightMap,R,0, 0);

%Time=(0:nTime)/nTime*24;
Position=2*R*H*(1:2*Site.NR-1)/(2*Site.NR-1);
fontsize=12;

[R2_ss RMSE_ss IntegralDif_ss r_ss]=FindErrors(Sin_t(:,1),Sin_t(:,2),Time,SinTable(:,2));
[R2_sn RMSE_sn IntegralDif_sn r_sn]=FindErrors(Sin_t(:,1),Sin_t(:,3),Time,SinTable(:,2*Site.NR));
[R2_sx RMSE_sx IntegralDif_sx r_sx]=FindErrors(Sin_x(:,1),Sin_x(:,2),Position,Sin_noon(2:2*Site.NR));
 
[R2_ls RMSE_ls IntegralDif_ls r_ls]=FindErrors(Lin_t(:,1),Lin_t(:,2),Time,LinTable(:,2));
[R2_ln RMSE_ln IntegralDif_ln r_ln]=FindErrors(Lin_t(:,1),Lin_t(:,3),Time,LinTable(:,2*Site.NR));
[R2_lx RMSE_lx IntegralDif_lx r_lx]=FindErrors(Lin_x(:,1),Lin_x(:,2),Position,LinTable(1,2:2*Site.NR));
 

E=[ R2_ss RMSE_ss IntegralDif_ss r_ss
    R2_sn RMSE_sn IntegralDif_sn r_sn
    R2_sx RMSE_sx IntegralDif_sx r_sx
    R2_ls RMSE_ln IntegralDif_ls r_ls
    R2_ln RMSE_ls IntegralDif_ln r_ln
    R2_lx RMSE_lx IntegralDif_lx r_lx];
E_=E(:,[1 3 4])
save('error','E_','-ascii');

fontsize=20;
gcafontsize=fontsize-4;
markers=['*','s','p','d'];
color1=rgb('DarkCyan');
color2=rgb('OrangeRed');
color3=rgb('DeepSkyBlue');
color4=rgb('Magenta');

color3=rgb('DarkCyan');
color4=rgb('OrangeRed');

%subplot(2,3,1),
close

p=plot(Sin_t(:,1),Sin_t(:,2),Time,SinTable(:,2));
xlabel('Time (hour)','fontsize',fontsize,'fontweight','b'),
ylabel('Shortwave Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
axis([0 24 0 600]),
set(gca,'fontsize',gcafontsize),
h_legend=legend({'Measured','Modeled'});
set(h_legend,'FontSize',fontsize-2,'Location','NorthEast');
set(p(1),'color',color1);
set(p(2),'color',color2);
set(p(1),'Marker',markers(1));
set(p(2),'Marker',markers(2));
set(gca,'LineStyle','-');
set(p,'MarkerSize',ceil(fontsize/20*10));
set(p,'LineWidth',ceil(fontsize/20*2));
print('-dpng',[Project '\ShortwaveNorth_Time' '.png'],'-r600');

%subplot(2,3,2),
p=plot(Sin_t(:,1),Sin_t(:,3),Time,SinTable(:,2*Site.NR));
xlabel('Time (hour)','fontsize',fontsize,'fontweight','b'),
ylabel('Shortwave Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
axis([0 24 0 600]),
set(gca,'fontsize',gcafontsize)
set(p(1),'color',color1);
set(p(2),'color',color2);
set(p(1),'Marker',markers(1));
set(p(2),'Marker',markers(2));
set(gca,'LineStyle','-');
set(p,'MarkerSize',ceil(fontsize/20*10));
set(p,'LineWidth',ceil(fontsize/20*2));
print('-dpng',[Project '\ShortwaveSouth_Time' '.png'],'-r600');



%subplot(2,3,4),
p=plot(Lin_t(:,1),Lin_t(:,2),Time,LinTable(:,2));
xlabel('Time (hour)','fontsize',fontsize,'fontweight','b'),
ylabel('Longwave Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
axis([0 24 200 350]),
set(gca,'fontsize',gcafontsize)
set(p(1),'color',color1);
set(p(2),'color',color2);
set(p(1),'Marker',markers(1));
set(p(2),'Marker',markers(2));
set(gca,'LineStyle','-');
set(p,'MarkerSize',ceil(fontsize/20*10));
set(p,'LineWidth',ceil(fontsize/20*2));
print('-dpng',[Project '\LongwaveNorth_Time' '.png'],'-r600');

%subplot(2,3,5),
p=plot(Lin_t(:,1),Lin_t(:,3),Time,LinTable(:,2*Site.NR));
xlabel('Time (hour)','fontsize',fontsize,'fontweight','b'),
ylabel('Longwave Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
axis([0 24 200 350]),
set(gca,'fontsize',gcafontsize)
set(p(1),'color',color1);
set(p(2),'color',color2);
set(p(1),'Marker',markers(1));
set(p(2),'Marker',markers(2));
set(gca,'LineStyle','-');
set(p,'MarkerSize',ceil(fontsize/20*10));
set(p,'LineWidth',ceil(fontsize/20*2));
print('-dpng',[Project '\LongwaveSouth_Time' '.png'],'-r600');


%subplot(2,3,3),
p=plot(Sin_x(:,1),Sin_x(:,2),Position,Sin_noon(2:2*Site.NR));
xlabel('x (m)','fontsize',fontsize,'fontweight','b'),
ylabel('Shortwave Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
axis([0 2*R*H 0 600]),
set(gca,'fontsize',gcafontsize),
h_legend=legend({'Measured','Modeled'});
set(h_legend,'FontSize',fontsize-2,'Location','NorthWest');
set(p(1),'color',color3);
set(p(2),'color',color4);
set(p(1),'Marker',markers(3));
set(p(2),'Marker',markers(4));
set(gca,'LineStyle','-');
set(p,'MarkerSize',ceil(fontsize/20*10));
set(p,'LineWidth',ceil(fontsize/20*2));
print('-dpng',[Project '\Shortwave_Space' '.png'],'-r600');



%subplot(2,3,6),
p=plot(Lin_x(:,1),Lin_x(:,2),Position,LinTable(1,2:2*Site.NR));
xlabel('x (m)','fontsize',fontsize,'fontweight','b'),
ylabel('Longwave Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
axis([0 2*R*H 200 300]),
set(gca,'fontsize',gcafontsize)
set(p(1),'color',color3);
set(p(2),'color',color4);
set(p(1),'Marker',markers(3));
set(p(2),'Marker',markers(4));
set(gca,'LineStyle','-');
set(p,'MarkerSize',ceil(fontsize/20*10));
set(p,'LineWidth',ceil(fontsize/20*2));
print('-dpng',[Project '\Longwave_Space' '.png'],'-r600');










% close
% p=plot(Sin_t(:,1),Sin_t(:,2),Time,SinTable(:,2),Lin_t(:,1),Lin_t(:,2),Time,LinTable(:,2));
% xlabel('Time (hour)','fontsize',fontsize,'fontweight','b'),
% ylabel('Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
% axis([0 24 0 600]),
% set(gca,'fontsize',gcafontsize),
% h_legend=legend({'Shortwave Measured','Shortwave Modeled','Longwave Measured','Longwave Modeled'});
% set(h_legend,'FontSize',fontsize-2,'Location','NorthEast');
% set(p(1),'color',color1);
% set(p(2),'color',color2);
% set(p(3),'color',color3);
% set(p(4),'color',color4);
% set(p(1),'Marker',markers(1));
% set(p(2),'Marker',markers(2));
% set(p(3),'Marker',markers(3));
% set(p(4),'Marker',markers(4));
% set(gca,'LineStyle','-');
% set(p,'MarkerSize',ceil(fontsize/20*10));
% set(p,'LineWidth',ceil(fontsize/20*2));
% print('-dpng',[Project '\North_Time' '.png'],'-r600');
% 
% p=plot(Sin_t(:,1),Sin_t(:,3),Time,SinTable(:,2*Site.NR),Lin_t(:,1),Lin_t(:,3),Time,LinTable(:,2*Site.NR));
% xlabel('Time (hour)','fontsize',fontsize,'fontweight','b'),
% ylabel('Radiation (W/m^2)','fontsize',fontsize,'fontweight','b'),
% axis([0 24 0 600]),
% set(gca,'fontsize',gcafontsize)
% set(p(1),'color',color1);
% set(p(2),'color',color2);
% set(p(3),'color',color3);
% set(p(4),'color',color4);
% set(p(1),'Marker',markers(1));
% set(p(2),'Marker',markers(2));
% set(p(3),'Marker',markers(3));
% set(p(4),'Marker',markers(4));
% set(gca,'LineStyle','-');
% set(p,'MarkerSize',ceil(fontsize/20*10));
% set(p,'LineWidth',ceil(fontsize/20*2));
% print('-dpng',[Project '\South_Time' '.png'],'-r600');
% 

end