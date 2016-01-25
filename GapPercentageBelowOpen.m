function Table=GapPercentageBelowOpen(Project,RBase)
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

RList=[0.25 0.5 1 2 5 10];
SlopeList=(0:15:45);
AspectList=(0:45:180);
DOYList=Site.DOY_start:10:Site.DOY_end;

 %RList=2;
 %SlopeList=(0:15:45);
 %AspectList=0;
 %plotoff=1;
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
        %[r,w] = meshgrid(dr/2:dr:R-dr/2,0:dw:2*pi);
        [r,w] = meshgrid(0:dr:R-dr,0:dw:2*pi);
        SVF = GapLocalSVF(R,r,w,Slope/180*pi);
        %SVF=zeros(Site.NW+1,Site.NR)+0.5;
        
        for Aspect=AspectList
            %mN_open_total =GapModel(H,HeightMap,100000,Slope,Aspect,Site,plotoff,SVF);
            %mN_open_total=mN_open_total(1);
            for DOY=DOYList
                Row=Row+1;  
                
                tmpSite.DOY_start=DOY;
                tmpSite.DOY_end=DOY+1;
                [mN mL mS Net Lnet Snet rTransect r w vN vLn vSn Sin Lin mSin mLin BelowOpen_temporal R_open  S_open L_open Lsky_open Lsnow_open]=GapModel(H,HeightMap,R,Slope,Aspect,tmpSite,plotoff,SVF);
                %BelowOpen_total=sum(sum(Net<mN_open_total))/((Site.NW+1)*Site.NR)*100;
                Table(Row,:)=[R Slope Aspect DOY BelowOpen_temporal ];
                TableTest(Row,:)=[DOY BelowOpen_temporal mN(1) R_open mS(1)  S_open mL(1)  L_open vN(1)/10];
                Progress=floor(Row/length(Table)*1000)/10;
                fprintf('Progress... %.1f%%\n',Progress);
            end
        end
    end
end
%plotyy(TableTest(:,1),TableTest(:,2),TableTest(:,1),TableTest(:,[3 4 9])),xlabel('DOY'),ylabel('Below Open (%)'),legend('Below Open','R_g_a_p','R_o_p_e_n','Variance')

save PercentageBelowOpen


load PercentageBelowOpen
close;
Rs_Filter=Table(:,2)==0&Table(:,3)==0;
SlopesSouth_Filter=Table(:,1)==RBase&Table(:,3)==0;
SlopesNorth_Filter=Table(:,1)==RBase&Table(:,3)==180;
Aspects_Filter=Table(:,1)==RBase&Table(:,2)==15;

RListMajor=[0.25 0.5 1 2 5 10];
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
  DListMajorStr=num2str(2*RListMajor');

for i=1:length(RListMajor)
    LegendR(i)={['D/H=' DListMajorStr(i,:)]};
end

DeltaR=TableTest(:,3)-TableTest(:,4);
DeltaS=TableTest(:,5)-TableTest(:,6);
DeltaL=TableTest(:,7)-TableTest(:,8);

GapPercentageBelowOpenPlot(Table, Rs_Filter, 1,RListMajor,'D/H', 'Area_R',fontsize,LEGEND_STAT,'NorthEast',xLim,yLim,LegendR);
GapPercentageBelowOpenPlot(Table, SlopesSouth_Filter, 2,SlopeListMajor,'South-facing Slope (^\circC)', 'Area_SlopeSouth',fontsize,LEGEND_STAT,'NorthEast',xLim,yLim,LegendSlope);
GapPercentageBelowOpenPlot(Table, SlopesNorth_Filter, 2,SlopeListMajor,'North-facing Slope (^\circC)', 'Area_SlopeNorth',fontsize,LEGEND_STAT,'SouthWest',xLim,yLim,LegendSlope);
GapPercentageBelowOpenPlot(Table, Aspects_Filter, 3,AspectListMajor,'Aspect (^\circC)', 'Area_Aspect',fontsize,LEGEND_STAT,'NorthEast',xLim,yLim,LegendAspect);

GapDeltaRPlot(Table, DeltaR, Rs_Filter, 1,RListMajor,'D/H', 'Delta_R',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendR,'\DeltaR (W/m^2)');
GapDeltaRPlot(Table, DeltaR, SlopesSouth_Filter, 2,SlopeListMajor,'South-facing Slope (^\circC)', 'Delta_SlopeSouth',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendSlope,'\DeltaR (W/m^2)');
GapDeltaRPlot(Table, DeltaR, SlopesNorth_Filter, 2,SlopeListMajor,'North-facing Slope (^\circC)', 'Delta_SlopeNorth',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendSlope,'\DeltaR (W/m^2)');
GapDeltaRPlot(Table, DeltaR, Aspects_Filter, 3,AspectListMajor,'Aspect (^\circC)', 'Delta_Aspect',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendAspect,'\DeltaR (W/m^2)');

LEGEND_STAT=1;
fontsize=24;

GapDeltaRPlot(Table, DeltaS, Rs_Filter, 1,RListMajor,'', 'Delta_R_Snet',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendR,'\DeltaS_N_e_t (W/m^2)');
GapDeltaRPlot(Table, DeltaS, SlopesSouth_Filter, 2,SlopeListMajor,'', 'Delta_SlopeSouth_Snet',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendSlope,'\DeltaS_N_e_t (W/m^2)');
GapDeltaRPlot(Table, DeltaS, SlopesNorth_Filter, 2,SlopeListMajor,'', 'Delta_SlopeNorth_Snet',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendSlope,'\DeltaS_N_e_t (W/m^2)');
GapDeltaRPlot(Table, DeltaS, Aspects_Filter, 3,AspectListMajor,'', 'Delta_Aspect_Snet',fontsize,LEGEND_STAT,'SouthWest',xLim,'auto',LegendAspect,'\DeltaS_N_e_t (W/m^2)');

GapDeltaRPlot(Table, DeltaL, Rs_Filter, 1,RListMajor,'', 'Delta_R_Lnet',fontsize,LEGEND_STAT,'NorthWest',xLim,'auto',LegendR,'\DeltaL_N_e_t (W/m^2)');
GapDeltaRPlot(Table, DeltaL, SlopesSouth_Filter, 2,SlopeListMajor,'', 'Delta_SlopeSouth_Lnet',fontsize,LEGEND_STAT,'NorthWest',xLim,'auto',LegendSlope,'\DeltaL_N_e_t (W/m^2)');
GapDeltaRPlot(Table, DeltaL, SlopesNorth_Filter, 2,SlopeListMajor,'', 'Delta_SlopeNorth_Lnet',fontsize,LEGEND_STAT,'NorthWest',xLim,'auto',LegendSlope,'\DeltaL_N_e_t (W/m^2)');
GapDeltaRPlot(Table, DeltaL, Aspects_Filter, 3,AspectListMajor,'','Delta_Aspect_Lnet',fontsize,LEGEND_STAT,'NorthWest',xLim,'auto',LegendAspect,'\DeltaL_N_e_t (W/m^2)');


end