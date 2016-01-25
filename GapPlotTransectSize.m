function GapPlotTransectSize(Project, rTransect, NetTable, LnetTable, SnetTable, Slope, Aspect)
 NetTransect=NetTable((NetTable(:,2)==Slope)&(NetTable(:,3)==Aspect),7:size(rTransect,2)+6);
 LnetTransect=LnetTable((LnetTable(:,2)==Slope)&(LnetTable(:,3)==Aspect),7:size(rTransect,2)+6);
 SnetTransect=SnetTable((SnetTable(:,2)==Slope)&(SnetTable(:,3)==Aspect),7:size(rTransect,2)+6);

 MeanNet=NetTable((NetTable(:,2)==Slope)&(NetTable(:,3)==Aspect),4);
 MeanSNet=NetTable((NetTable(:,2)==Slope)&(NetTable(:,3)==Aspect),6);
 MeanLNet=NetTable((NetTable(:,2)==Slope)&(NetTable(:,3)==Aspect),5);

RList=unique(NetTable((NetTable(:,2)==Slope)&(NetTable(:,3)==Aspect),1));

%PlotCurveList(NetTransect',RList',rTransect','r/R','Net (W/m^2)','Transectional variation of net radiation for R/H',['NetTransect-R ' 'Slope=' num2str(Slope,'%.1f') ' Aspect=' num2str(Aspect,'%.0f') '.png']);
%PlotCurveList(LnetTransect',RList',rTransect','r/R','L_n_e_t (W/m^2)','Transectional variation of L_n_e_t for R/H',['LnetTransect-R ' 'Slope=' num2str(Slope,'%.1f') ' Aspect=' num2str(Aspect,'%.0f') '.png']);
%PlotCurveList(SnetTransect',RList',rTransect','r/R','S_n_e_t (W/m^2)','Transectional variation of S_n_e_t for R/H',['SnetTransect-R ' 'Slope=' num2str(Slope,'%.1f') ' Aspect=' num2str(Aspect,'%.0f') '.png']);

Legend=cellstr(num2str(RList));
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
FontSize=20;

%axes(h(1)),
PlotCurveAll(rTransect',LnetTransect','','r/R','L_N_e_t (W/m^2)',Legend,[Project '\Lnet with Size, Aspect=' num2str(Aspect,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],FontSize,0);
%axes(h(2)),
PlotCurveAll(rTransect',SnetTransect','','r/R','S_N_e_t (W/m^2)',Legend,[Project '\Snet with Size, Aspect=' num2str(Aspect,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],FontSize,1);
%axes(h(3)),
PlotCurveAll(rTransect',NetTransect','','r/R','Net (W/m^2)',Legend,[Project '\Net with Size, Aspect=' num2str(Aspect,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],FontSize,1);

%mtit(1,'Spatial variability of radiation along gap transect for different gap sizes','Position',[.5 1.05],'fontweight','b');
%print('-dpng',[Project '\TransectionalGapSize, Aspect=' num2str(Aspect,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],'-r600');

end
