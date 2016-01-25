Site=GapForestSite('Greenville',45.46,-69.58,423,4.9568,28.3324,9.1677,217.8418,4);
[rTransect NetTable LnetTable SnetTable]=GapTableTransections(Site);

GapPlotShadowOnGapDOY(2);
GapPlotShadowOnGapSlope(80.5,2);
GapPlotShadowOnGapAspect(80.5,2);
GapPlotShadowOnGapSize(80.5);


close
[meanNet meanLnet meanSnet Net Lnet Snet rTransect2]=GapModel(2);

close
GapPlotTransectAspect(rTransect, NetTable, LnetTable, SnetTable, 30, 2);
GapPlotTransectGapSize(rTransect, NetTable, LnetTable, SnetTable, 0, 0);
GapPlotTransectSlope(rTransect, NetTable, LnetTable, SnetTable, 2, 0);

close
[meanNet meanLnet meanSnet Net Lnet Snet rTransect]=GapModel(2);
Table=GapTableAllSizeSlopeAspects(Site);
GapPlotAllSizeSlopeAspects(Table,2);

