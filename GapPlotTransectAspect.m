function GapPlotTransectAspect(Project, rTransect, NetTable, LnetTable, SnetTable, Slope, R)
 NetTransect=NetTable((NetTable(:,2)==Slope)&(NetTable(:,1)==R),7:size(rTransect,2)+6);
 LnetTransect=LnetTable((LnetTable(:,2)==Slope)&(LnetTable(:,1)==R),7:size(rTransect,2)+6);
 SnetTransect=SnetTable((SnetTable(:,2)==Slope)&(SnetTable(:,1)==R),7:size(rTransect,2)+6);

AspectList=unique(NetTable((NetTable(:,2)==Slope)&(NetTable(:,1)==R),3));
Legend=cellstr(num2str(AspectList));
forplot=1:3:size(rTransect,2);
rTransect=rTransect(:,forplot);
LnetTransect=LnetTransect(:,forplot);
SnetTransect=SnetTransect(:,forplot);
NetTransect=NetTransect(:,forplot);

%PlotCurveList(NetTransect',AspectList',rTransect','r/R','Net (W/m^2)','Transectional variation of net radiation for aspect',['NetTransect-Aspect ' 'Slope=' num2str(Slope,'%.1f') ' R=' num2str(R,'%.0f') '.png']);
%PlotCurveList(LnetTransect',AspectList',rTransect','r/R','L_n_e_t (W/m^2)','Transectional variation of L_n_e_t for aspect',['LnetTransect-Aspect ' 'Slope=' num2str(Slope,'%.1f') ' R=' num2str(R,'%.0f') '.png']);
%PlotCurveList(SnetTransect',AspectList',rTransect','r/R','S_n_e_t (W/m^2)','Transectional variation of S_n_e_t for aspect',['SnetTransect-Aspect ' 'Slope=' num2str(Slope,'%.1f') ' R=' num2str(R,'%.0f') '.png']);
clf;
FontSize=16;
% set(gcf, 'Position', [250,150, 1000, 750],'PaperPositionMode','auto');
% h=tight_subplot(2, 2,[.07 0.09],[.06 .01],[.07 .01]);
% axis off
% x3=get(h(3),'Position');
% x4=get(h(4),'Position');
% set(h(3),'Position',.5*(x3+x4));

FontSize=20;


%axes(h(1)),
PlotCurveAll(rTransect',LnetTransect','','r/R','L_N_e_t (W/m^2)',Legend,[Project '\Lnet with Aspect, R=' num2str(R,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],FontSize,0);
%axes(h(2)),
PlotCurveAll(rTransect',SnetTransect','','r/R','S_N_e_t (W/m^2)',Legend,[Project '\Snet with Aspect, R=' num2str(R,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],FontSize,1);
%axes(h(3)),
PlotCurveAll(rTransect',NetTransect','','r/R','Net (W/m^2)',Legend,[Project '\Net with Aspect, R=' num2str(R,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],FontSize,1);


%mtit(1,'Spatial variability of radiation along gap transect for different aspects','Position',[.5 1.05],'fontweight','b');

%print('-dpng',[Project '\TransectionalAspect, R=' num2str(R,'%.1f') 'Slope=' num2str(Slope,'%.f') '.png'],'-r600');

end
