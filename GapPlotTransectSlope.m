function GapPlotTransectSlope(Project, rTransect, NetTable, LnetTable, SnetTable, R, Aspect)
NetTransect=NetTable((NetTable(:,1)==R)&(NetTable(:,3)==Aspect),7:size(rTransect,2)+6);
LnetTransect=LnetTable((LnetTable(:,1)==R)&(LnetTable(:,3)==Aspect),7:size(rTransect,2)+6);
SnetTransect=SnetTable((SnetTable(:,1)==R)&(SnetTable(:,3)==Aspect),7:size(rTransect,2)+6);

SlopeList=unique(NetTable((NetTable(:,1)==R)&(NetTable(:,3)==Aspect),2));
Legend=cellstr(num2str(SlopeList));
forplot=1:3:size(rTransect,2);
rTransect=rTransect(:,forplot);
LnetTransect=LnetTransect(:,forplot);
SnetTransect=SnetTransect(:,forplot);
NetTransect=NetTransect(:,forplot);

clf;
% set(gcf, 'Position', [250,150, 1000, 750],'PaperPositionMode','auto');
% FontSize=16;
% h=tight_subplot(2, 2,[.07 0.09],[.06 .01],[.07 .01]);
% axis off
% x3=get(h(3),'Position');
% x4=get(h(4),'Position');
% set(h(3),'Position',.5*(x3+x4));
% %PlotCurveList(NetTransect',SlopeList',rTransect','r/R','Net (W/m^2)','Transectional variation of net radiation for slopes',['NetTransect-Slopes ' 'R=' num2str(R,'%.1f') ' Aspect=' num2str(Aspect,'%.0f') '.png']);
% 
FontSize=20;


%axes(h(1)),
PlotCurveAll(rTransect',LnetTransect','','r/R','L_N_e_t (W/m^2)',Legend,[Project '\Lnet with Slope, Aspect=' num2str(Aspect,'%.1f') 'R=' num2str(R,'%.f') '.png'],FontSize,0);
%axes(h(2)),
PlotCurveAll(rTransect',SnetTransect','','r/R','S_N_e_t (W/m^2)',Legend,[Project '\Snet with Slope, Aspect=' num2str(Aspect,'%.1f') 'R=' num2str(R,'%.f') '.png'],FontSize,1);
%axes(h(3)),
PlotCurveAll(rTransect',NetTransect','','r/R','Net (W/m^2)',Legend,[Project '\Net with Slope, Aspect=' num2str(Aspect,'%.1f') 'R=' num2str(R,'%.f') '.png'],FontSize,1);


%mtit(1,'Spatial variability of radiation along gap transect for different slopes','Position',[.5 1.05],'fontweight','b');
%print('-dpng',[Project '\TransectionalSlope, Aspect=' num2str(Aspect,'%.1f') 'R=' num2str(R,'%.f') '.png'],'-r600');

end
