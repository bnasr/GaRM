function GapPlotShadowOnGapAspect(DOY,R,Project)
Site=GapForestSite(Project);

Slope=30;

clf;
set(gcf, 'Position', [50, 50, 530, 900],'PaperPositionMode','auto');
h=tight_subplot(3, 2,[.07 -.4],[.01 .05],[-.2 -.2]);

axes(h(1)),GapShadowOnGap(DOY,R,Slope,0,Site,{'(a)';'\phi_s=0\circ'});
axes(h(3)),GapShadowOnGap(DOY,R,Slope,36,Site,{'(b)';'\phi_s=36\circ'});
axes(h(5)),GapShadowOnGap(DOY,R,Slope,72,Site,{'(c)';'\phi_s=72\circ'});
axes(h(2)),GapShadowOnGap(DOY,R,Slope,108,Site,{'(d)';'\phi_s=108\circ'});
axes(h(4)),GapShadowOnGap(DOY,R,Slope,144,Site,{'(e)';'\phi_s=144\circ'});
axes(h(6)),GapShadowOnGap(DOY,R,Slope,180,Site,{'(f)';'\phi_s=180\circ'});

axes(h(2)),
AspectArrow=0;
arrow(0.95*[R R],0.95*[R+0.3*R*sind(AspectArrow) R+0.3*R*cosd(AspectArrow)],'Length',16);
text(R-0.15*R*sind(AspectArrow)-0.11*R, R-0.15*R*cosd(AspectArrow),'N','fontweight','b','fontsize',16);

%set(gcf,'PaperUnits','points','PaperPosition',[0 0 500 500]);
print('-dpng',[Project '\ShadowAspect, R=' num2str(R,'%.1f') 'Slope=' num2str(Slope,'%.f') ' DOY=' num2str(DOY,'%.f')  '.png'],'-r600');

end