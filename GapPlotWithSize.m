function GapPlotWithSize(NetTable,Project)
NetTable=NetTable(:,(1:6));
SlopeBase=15;
AspectBase=0;

NetTableSlope=NetTable(NetTable(:,3)==AspectBase,:);
NetTableAspect=NetTable(NetTable(:,2)==SlopeBase,:);

SlopeList=unique(NetTable(NetTable(:,3)==AspectBase,2));
AspectList=unique(NetTable(NetTable(:,2)==SlopeBase,3));
RList=unique(NetTable(:,1));
NetSlope=zeros(length(RList),length(SlopeList));
LnetSlope=NetSlope;
SnetSlope=NetSlope;

NetAspect=zeros(length(RList),length(AspectList));
LnetAspect=NetAspect;
SnetAspect=NetAspect;

i=0;
for Slope=SlopeList'
    i=i+1;
    NetSlope(:,i)=NetTableSlope(NetTableSlope(:,2)==Slope,4);
    LnetSlope(:,i)=NetTableSlope(NetTableSlope(:,2)==Slope,5);
    SnetSlope(:,i)=NetTableSlope(NetTableSlope(:,2)==Slope,6);
end    

i=0;
for Aspect=AspectList'
    i=i+1;
    NetAspect(:,i)=NetTableAspect(NetTableAspect(:,3)==Aspect,4);
    LnetAspect(:,i)=NetTableAspect(NetTableAspect(:,3)==Aspect,5);
    SnetAspect(:,i)=NetTableAspect(NetTableAspect(:,3)==Aspect,6);
end    


LegendSlope=cellstr(num2str(SlopeList));
LegendAspect=cellstr(num2str(AspectList));

FontSize=20;
DList=2*RList;

LegPos='NorthWest';
AxisHandle=gca;
XTICK=log(DList);
XTICKLABEL=DList;
xLim=[min(XTICK) max(XTICK)];
yLim='auto';
yLimNet=[20 130];
LegendSlope={
    '\beta=0^\circ'
    '\beta=15^\circ'
    '\beta=30^\circ'
    '\beta=45^\circ'
    };

LegendAspect={
    'South'
    'Southeast'
    'East'
    'Northeast'
    'North'
    };
[vmin imin]=min(NetSlope);
Dmin=DList(imin);
ToSmall=vmin./NetSlope(1,:)*100;
ToLarge=vmin./NetSlope(end,:)*100;
minTableSlope=[Dmin ToSmall' ToLarge'];
num2str(minTableSlope,'%.1f %.1f %.1f')
save('minTableSlope.txt','minTableSlope','-ascii')

[vmin imin]=min(NetAspect);
Dmin=DList(imin);
ToSmall=vmin./NetAspect(1,:)*100;
ToLarge=vmin./NetAspect(end,:)*100;
minTableAspect=[Dmin ToSmall' ToLarge'];
num2str(minTableAspect,'%.1f %.1f %.1f')
save('minTableAspect.txt','minTableAspect','-ascii')


PlotCurveAll2(log(DList),NetSlope,'','D/H','Net (W/m^2)',LegendSlope,[Project '\NetSlope.png'],FontSize,1,LegPos,xLim,yLimNet,AxisHandle,XTICK,XTICKLABEL);
PlotCurveAll2(log(DList),LnetSlope,'','D/H','L_N_e_t (W/m^2)',LegendSlope,[Project '\LnetSlope.png'],FontSize,1,LegPos,xLim,yLim,AxisHandle,XTICK,XTICKLABEL);
PlotCurveAll2(log(DList),SnetSlope,'','D/H','S_N_e_t (W/m^2)',LegendSlope,[Project '\SnetSlope.png'],FontSize,0,LegPos,xLim,yLim,AxisHandle,XTICK,XTICKLABEL);

PlotCurveAll2(log(DList),NetAspect,'','D/H','Net (W/m^2)',LegendAspect,[Project '\NetAspect.png'],FontSize,1,LegPos,xLim,yLimNet,AxisHandle,XTICK,XTICKLABEL);
PlotCurveAll2(log(DList),LnetAspect,'','D/H','L_N_e_t (W/m^2)',LegendAspect,[Project '\LnetAspect.png'],FontSize,1,LegPos,xLim,yLim,AxisHandle,XTICK,XTICKLABEL);
PlotCurveAll2(log(DList),SnetAspect,'','D/H','S_N_e_t (W/m^2)',LegendAspect,[Project '\SnetAspect.png'],FontSize,0,LegPos,xLim,yLim,AxisHandle,XTICK,XTICKLABEL);

[axout,h1,h2]=plotyy(log(DList),NetSlope(:,1),log(DList),[SnetSlope(:,1) LnetSlope(:,1) ]);

    xlabel('D/H','fontsize',FontSize,'fontweight','b');
   h_legend=legend('Net','S_N_e_t','L_N_e_t');
   set(h_legend,'FontSize',FontSize-4,'Location','NorthWest');

    set(h1,'LineStyle','-','LineWidth',ceil(FontSize/20*3),'marker','*');
    set(h2(1),'LineStyle',':','LineWidth',ceil(FontSize/20*4),'marker','v');
    set(h2(2),'LineStyle','--','LineWidth',ceil(FontSize/20*3),'marker','x');

    set(get(axout(1),'Ylabel'),'String','Net Radiation (W/m^2)','FontSize',FontSize,'FontWeight','b','Color','black');
    set(get(axout(2),'Ylabel'),'String','S_N_e_t and L_N_e_t (W/m^2)','FontSize',FontSize,'FontWeight','b','Color','black'); 
    set(axout,'FontSize',FontSize-4,'ycolor','black');
    y1range=[min(NetSlope(:,1)) max(NetSlope(:,1))];
    y2range=[min(min([SnetSlope(:,1),LnetSlope(:,1)])) max(max([SnetSlope(:,1),LnetSlope(:,1)]))];
     y1range =[30 90];   
     y2range =[-40 130];
  
    set(axout(1),'YLim',y1range,'YTick',(-900:10:1000),'XLim',xLim,'XTick',XTICK,'XTickLabel',XTICKLABEL);
    set(axout(2),'YLim',y2range,'YTick',(-900:30:1000),'XLim',xLim,'XTick',XTICK,'XTickLabel',XTICKLABEL);

    pos=get(get(axout(2),'Ylabel'),'Position');
    set(get(axout(2),'Ylabel'),'Position',pos+[-.4 0 0])

    grid on;
    print('-dpng', '-r600' , [Project '\Flat-Nets']);

end

