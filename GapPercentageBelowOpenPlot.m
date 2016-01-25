function p=GapPercentageBelowOpenPlot(Table, Filter, Filter_Col,Q_ListMajor,Filter_name, FileName,fontsize,LEGEND_STAT,LegPos,xLim,yLim,Legends)
X=unique(Table(Filter,4));
%Q=unique(Table(Filter,Filter_Col));
Q=Q_ListMajor';
Y=zeros(length(X),length(Q));

for i=1:length(Q)
    Y(:,i)=Table(Filter&Table(:,Filter_Col)==Q(i),5);
end
%LEGENDS=num2str( Q)';
XTICK=[-10 (0:20:365)];
XTICKLABEL=mod(XTICK,365);

p=PlotCurveAll2(X,100-Y,Filter_name,'Day of Year','\Lambda (%)',Legends,FileName,fontsize,LEGEND_STAT,LegPos,xLim,yLim,gca,XTICK,XTICKLABEL);
end