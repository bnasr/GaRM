function GapMakePlotsForGapPaper(Project)
if nargin==0
    Project='.';
end

%DOY=80.5;

D=4;
R=D/2;
H=25;
HeightMap=0;
Slope=0;
Aspect=0;
Site=GapForestSite(Project);
close all;


%  [meanNet meanLnet meanSnet Net Lnet Snet rTransect]=GapModel(H,HeightMap,R,Slope,Aspect,Project,2);
  [mN mL mS Net Lnet Snet rTransect r w vN vLn vSn]=GapModel(H,HeightMap,R,Slope,Aspect,Site,2);

% GapPlotShadowOnGapSize(DOY,Slope,Aspect,Project)
% GapPlotShadowOnGapDOY(R,Slope,Aspect,Project)
% GapPlotShadowOnGapSlope(DOY,R,Project)
% GapPlotShadowOnGapAspect(DOY,R,Project)
% close

close

[rTransect NetTable LnetTable SnetTable]=GapTableTransections(H,HeightMap,Project);
save([Project '\Table'],'Project','rTransect', 'NetTable', 'LnetTable', 'SnetTable','R','Slope','Aspect');
% GapPlotTransectSlope(Project,rTransect, NetTable, LnetTable, SnetTable, R, Aspect);
% GapPlotTransectSize(Project, rTransect, NetTable, LnetTable, SnetTable, Slope, Aspect);
% GapPlotTransectAspect(Project, rTransect, NetTable, LnetTable, SnetTable, 30, R);
GapPlotWithSize(NetTable,Project);

%GapPlotMeanVarAtSlopesAspects(H,HeightMap,R,Project);
close
GapPercentageBelowOpen(Project,R);


close
GapDayEqualOpenGapNew(Project);

%Table=GapTableAllSizeSlopeAspects(Project);
%save([Project '\table'],'R','Project','Table');
%GapPlotAllSizeSlopeAspects(Project,Table,R)
%close

end
