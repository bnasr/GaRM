function GapPlotShadowOnGapSize(DOY,Slope,Aspect,Project)
Site=GapForestSite(Project);


clf;
set(gcf, 'Position', [50, 50, 530, 900],'PaperPositionMode','auto');
h=tight_subplot(3, 2,[.07 -.4],[.01 .05],[-.2 -.2]);

axes(h(1)),GapShadowOnGap(DOY,0.2,Slope,Aspect,Site,{'(a)';'R=0.2 m'});
axes(h(2)),GapShadowOnGap(DOY,.5,Slope,Aspect,Site,{'(b)';'R=0.5 m'});
axes(h(3)),GapShadowOnGap(DOY,1,Slope,Aspect,Site,{'(c)';'R=1 m'});
axes(h(4)),GapShadowOnGap(DOY,2,Slope,Aspect,Site,{'(d)';'R=2 m'});
axes(h(5)),GapShadowOnGap(DOY,5,Slope,Aspect,Site,{'(e)';'R=5 m'});
axes(h(6)),GapShadowOnGap(DOY,10,Slope,Aspect,Site,{'(f)';'R=10 m'});

axes(h(2)),
AspectArrow=0;
R=0.5;
arrow(0.95*[R R],0.95*[R+0.3*R*sind(AspectArrow) R+0.3*R*cosd(AspectArrow)],'Length',16);
text(R-0.15*R*sind(AspectArrow)-0.11*R, R-0.15*R*cosd(AspectArrow),'N','fontweight','b','fontsize',16);

%set(gcf,'PaperUnits','points','PaperPosition',[0 0 500 500]);
print('-dpng',[Project '\ShadowSize, Slope=' num2str(Slope,'%.f')  'Aspect=' num2str(Aspect,'%.f')  ' DOY=' num2str(DOY,'%.f')  '.png'],'-r600');

end