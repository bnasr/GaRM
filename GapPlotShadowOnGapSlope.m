function GapPlotShadowOnGapSlope(DOY,R,Project)
Site=GapForestSite(Project);

clf;
set(gcf, 'Position', [50, 50, 530, 900],'PaperPositionMode','auto');
h=tight_subplot(3, 2,[.07 -.4],[.01 .05],[-.2 -.2]);

axes(h(1)),GapShadowOnGap(DOY,R,0,0,Site,{'(a)';'\beta=0\circ'});
axes(h(3)),GapShadowOnGap(DOY,R,15,0,Site,{'(b)';'\beta=15\circ'});
axes(h(5)),GapShadowOnGap(DOY,R,30,0,Site,{'(c)';'\beta=30\circ'});
axes(h(2)),GapShadowOnGap(DOY,R,0,180,Site,{'(d)';'\beta=0\circ'});
axes(h(4)),GapShadowOnGap(DOY,R,15,180,Site,{'(e)';'\beta=15\circ'});
axes(h(6)),GapShadowOnGap(DOY,R,30,180,Site,{'(f)';'\beta=30\circ'});

axes(h(2)),
AspectArrow=0;
arrow(0.95*[R R],0.95*[R+0.3*R*sind(AspectArrow) R+0.3*R*cosd(AspectArrow)],'Length',16);
text(R-0.15*R*sind(AspectArrow)-0.11*R, R-0.15*R*cosd(AspectArrow),'N','fontweight','b','fontsize',16);

%set(gcf,'PaperUnits','points','PaperPosition',[0 0 500 500]);
print('-dpng',[Project '\ShadowSlope, R=' num2str(R,'%.1f') ' DOY=' num2str(DOY,'%.f')  '.png'],'-r600');

end