function Table=GapDayEqualOpenGap(Project)
if nargin==0
    Project='.';
end
Site=GapForestSite(Project);
Site.eSky=mean(Site.eSky)*ones(size(Site.eSky));
Site.RH=mean(Site.RH)*ones(size(Site.RH));

tmpSite=Site;

plotoff=1;
H=25;
HeightMap=0;

RList=[ 0.5 1 2 ];
RList=[  2 ];
SlopeList=(0:2.5:45);
AspectList=(0:5:180);
DOYList=(0:5:365);
DOYList=(-9:5:174);

% RList=2;
% SlopeList=0;
% AspectList=0;
% plotoff=1;
%DOYList=42:44;

Table=zeros(length(RList)*length(SlopeList)*length(AspectList)*length(DOYList),5);
TableTest=zeros(length(RList)*length(SlopeList)*length(AspectList)*length(DOYList),9);

Row=0;
% DOYList2=Site.DOY_start:.1:Site.DOY_end;
% 
%     [Tair Tsnow Tdp]=GapTemperature(DOYList2',Site.T_m,Site.T_yrange,Site.T_drange,Site.T_phase,Site.RH(mod(ceil(DOYList2),365)+1));

for R=RList
    for Slope=SlopeList
        
        dr=R/Site.NR;
        dw=2*pi/Site.NW;
        [r,w] = meshgrid(dr/2:dr:R-dr/2,0:dw:2*pi);
        SVF = GapLocalSVF(R,r,w,Slope/180*pi);
        %SVF=zeros(Site.NW+1,Site.NR)+0.5;
        
        for Aspect=AspectList
            %mN_open_total =GapModel(H,HeightMap,100000,Slope,Aspect,Site,plotoff,SVF);
            %mN_open_total=mN_open_total(1);
            for DOY=DOYList
                Row=Row+1;  
                
                %tmpSite.DOY_start=DOY;
                tmpSite.DOY_end=DOY;
                [mN mL mS Net Lnet Snet rTransect r w vN vLn vSn Sin Lin mSin mLin BelowOpen_temporal R_open  S_open L_open Lsky_open Lsnow_open]=GapModel(H,HeightMap,R,Slope,Aspect,tmpSite,plotoff,SVF);
                %BelowOpen_total=sum(sum(Net<mN_open_total))/((Site.NW+1)*Site.NR)*100;
                Table(Row,:)=[R Slope Aspect DOY BelowOpen_temporal ];
                TableTest(Row,:)=[DOY BelowOpen_temporal mN(1) R_open mS(1)  S_open mL(1)  L_open vN(1)/10];
                Progress=floor(Row/length(Table)*100000)/1000;
                fprintf('Progress... %.2f%%\r',Progress);
            end
        end
    end
end
%plotyy(TableTest(:,1),TableTest(:,2),TableTest(:,1),TableTest(:,[3 4 9])),xlabel('DOY'),ylabel('Below Open (%)'),legend('Below Open','R_g_a_p','R_o_p_e_n','Variance')

save TableDayEqual


load TableDayEqual
close;
Rs_Filter=Table(:,2)==0&Table(:,3)==0;
SlopesSouth_Filter=Table(:,1)==2&Table(:,3)==0;
SlopesNorth_Filter=Table(:,1)==2&Table(:,3)==180;
Aspects_Filter=Table(:,1)==2&Table(:,2)==15;

RListMajor=[0.2 0.5 1 2 5 10 20];
SlopeListMajor=(0:15:45);
AspectListMajor=(0:45:180);

fontsize=20;
LEGEND_STAT=0;
LegPos='SouthEast';
yLim=[0 100];
xLim=[Site.DOY_start Site.DOY_end];

%subplot(3,2,[5 6]),GapPercentageBelowOpenColorMap(Table, 2,170)

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
 RListMajorStr=num2str(RListMajor');
 
for i=1:length(RListMajor)
    LegendR(i)={['R/H=' RListMajorStr(i,:)]};
end

DeltaR=TableTest(:,3)-TableTest(:,4);

DayEqualOpenGap=[Table(:,(1:4)) DeltaR];
%RBase=1;
DayMapforRSlopeASpect=zeros(length(RList)*length(SlopeList)*length(AspectList),4);
Row=0;
for R=RList
    for Slope=SlopeList
        for Aspect=AspectList 
            Row=Row+1;
            DayDeltaR=DayEqualOpenGap(DayEqualOpenGap(:,1)==R&DayEqualOpenGap(:,2)==Slope&DayEqualOpenGap(:,3)==Aspect,[4,5]);
            ichange=find(diff(sign(DayDeltaR(:,2)))==-2);
            if isempty(ichange)
                Day=999;
            else
                Day=-(DayDeltaR(ichange,1)-DayDeltaR(ichange+1,1))/ (DayDeltaR(ichange,2)-DayDeltaR(ichange+1,2))*DayDeltaR(ichange,2)+DayDeltaR(ichange,1);
            end
%             [Row ichange]
%             [Day DayDeltaR(ichange,1) DayDeltaR(ichange,2) DayDeltaR(ichange+1,1) DayDeltaR(ichange+1,2) ]
            DayMapforRSlopeASpect(Row,:)=[R, Slope, Aspect, Day];
        end
    end
    
end

RBase=2;
DayMapforSlopeASpect=zeros(length(SlopeList),length(AspectList));

iSlope=0;

for Slope=SlopeList
    iSlope=iSlope+1;
    iAspect=0;
    for Aspect=AspectList 
       iAspect=iAspect+1;
       DayMapforSlopeASpect(iSlope,iAspect)= DayMapforRSlopeASpect(DayMapforRSlopeASpect(:,1)==RBase&DayMapforRSlopeASpect(:,2)==Slope&DayMapforRSlopeASpect(:,3)==Aspect,4);
       %[Slope Aspect DayMapforRSlopeASpect(DayMapforRSlopeASpect(:,1)==RBase&DayMapforRSlopeASpect(:,2)==Slope&DayMapforRSlopeASpect(:,3)==Aspect,4)]
    end
end

[Slope, Aspect]=meshgrid(SlopeList, AspectList);

pcolor(Aspect ,Slope,DayMapforSlopeASpect');
caxis([-10 173]);
colorbar

% GapPercentageBelowOpenPlot(Table, Rs_Filter, 1,RListMajor,'R/H', 'Area_R',fontsize,LEGEND_STAT,'NorthEast',xLim,yLim,LegendR);
% GapPercentageBelowOpenPlot(Table, SlopesSouth_Filter, 2,SlopeListMajor,'South-facing Slope (^\circC)', 'Area_SlopeSouth',fontsize,LEGEND_STAT,'NorthEast',xLim,yLim,LegendSlope);
% GapPercentageBelowOpenPlot(Table, SlopesNorth_Filter, 2,SlopeListMajor,'North-facing Slope (^\circC)', 'Area_SlopeNorth',fontsize,LEGEND_STAT,'SouthWest',xLim,yLim,LegendSlope);
% GapPercentageBelowOpenPlot(Table, Aspects_Filter, 3,AspectListMajor,'Aspect (^\circC)', 'Area_Aspect',fontsize,LEGEND_STAT,'NorthEast',xLim,yLim,LegendAspect);
% 
% GapDeltaRPlot(Table, DeltaR, Rs_Filter, 1,RListMajor,'R/H', 'Delta_R',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendR);
% GapDeltaRPlot(Table, DeltaR, SlopesSouth_Filter, 2,SlopeListMajor,'South-facing Slope (^\circC)', 'Delta_SlopeSouth',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendSlope);
% GapDeltaRPlot(Table, DeltaR, SlopesNorth_Filter, 2,SlopeListMajor,'North-facing Slope (^\circC)', 'Delta_SlopeNorth',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendSlope);
% GapDeltaRPlot(Table, DeltaR, Aspects_Filter, 3,AspectListMajor,'Aspect (^\circC)', 'Delta_Aspect',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendAspect);


end