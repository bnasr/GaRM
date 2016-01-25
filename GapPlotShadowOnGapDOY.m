function GapPlotShadowOnGapDOY(R,Slope,Aspect,Project)
Site=GapForestSite(Project);


DOY1=-10.5;
DOY2=173.5;
HOUR=1.5/24;
clf;

set(gcf, 'Position', [50, 50, 530, 900],'PaperPositionMode','auto');
h=tight_subplot(3, 2,[.07 -.4],[.01 .05],[-.2 -.2]);

axes(h(1)),GapShadowOnGap(DOY1-2*HOUR,R,Slope,Aspect,Site,'(a)');
axes(h(3)),GapShadowOnGap(DOY1-HOUR,R,Slope,Aspect,Site,'(b)')
axes(h(5)),GapShadowOnGap(DOY1,R,Slope,Aspect,Site,'(c)')

axes(h(2)),GapShadowOnGap(DOY2-2*HOUR,R,Slope,Aspect,Site,'(d)');
axes(h(4)),GapShadowOnGap(DOY2-HOUR,R,Slope,Aspect,Site,'(e)')
axes(h(6)),GapShadowOnGap(DOY2,R,Slope,Aspect,Site,'(f)')

axes(h(2)),
AspectArrow=0;
arrow(0.95*[R R],0.95*[R+0.3*R*sind(AspectArrow) R+0.3*R*cosd(AspectArrow)],'Length',16);
text(R-0.15*R*sind(AspectArrow)-0.11*R, R-0.15*R*cosd(AspectArrow),'N','fontweight','b','fontsize',16);

%set(gcf,'PaperUnits','points','PaperPosition',[0 0 500 500]);
print('-dpng',[Project '\ShadowDOY, R=' num2str(R,'%.1f') ' Slope=' num2str(Slope,'%.f') ' Aspect=' num2str(Aspect,'%.f') '.png'],'-r600');

end