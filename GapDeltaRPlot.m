function p=GapDeltaRPlot(Table, DeltaR, Filter, Filter_Col,Q_ListMajor,Filter_name, FileName,fontsize,LEGEND_STAT,LegPos,xLim,yLim,Legends,YLabel)
X=unique(Table(Filter,4));
%Q=unique(Table(Filter,Filter_Col));
Q=Q_ListMajor';
Y=zeros(length(X),length(Q));

for i=1:length(Q)
    Y(:,i)=DeltaR(Filter&Table(:,Filter_Col)==Q(i));
end
%LEGENDS=num2str( Q)';
XTICK=[-10 (0:20:365)];
XTICKLABEL=mod(XTICK,365);
p=PlotCurveAll2(X,Y,Filter_name,'Day of Year',YLabel,Legends,FileName,fontsize,LEGEND_STAT,LegPos,xLim,yLim,get(gcf,'CurrentAxes'),XTICK,XTICKLABEL);
end