function Table=GapDayEqualOpenGapNew_test

    Project='.';

Site=GapForestSite(Project);
Site.eSky=mean(Site.eSky)*ones(size(Site.eSky));
Site.RH=mean(Site.RH)*ones(size(Site.RH));

tmpSite=Site;

plotoff=1;
H=25;
HeightMap=0;

RList=[  2 ];
SlopeList=(0:5:45);
AspectList=0;%(0:1:180);
DOYList=(-10:10:355);
%DOYList=(-9:5:174);
%DOYList=(-10:10:170);

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
                
                tmpSite.DOY_start=DOY;
                tmpSite.DOY_end=DOY+1;
                [mN mL mS Net Lnet Snet rTransect r w vN vLn vSn Sin Lin mSin mLin BelowOpen_temporal R_open  S_open L_open Lsky_open Lsnow_open]=GapModel(H,HeightMap,R,Slope,Aspect,tmpSite,plotoff,SVF);
                %BelowOpen_total=sum(sum(Net<mN_open_total))/((Site.NW+1)*Site.NR)*100;
                Table(Row,:)=[R Slope Aspect DOY BelowOpen_temporal ];
                TableTest(Row,:)=[DOY BelowOpen_temporal mN(1) R_open mS(1)  S_open mL(1)  L_open vN(1)/10];
                Progress=floor(Row/length(Table)*100000)/1000;
                fprintf('Progress... %.1f%%\r',Progress);
            end
        end
    end
end
%plotyy(TableTest(:,1),TableTest(:,2),TableTest(:,1),TableTest(:,[3 4 9])),xlabel('DOY'),ylabel('Below Open (%)'),legend('Below Open','R_g_a_p','R_o_p_e_n','Variance')

save TableDayEqual


%load TableDayEqual

%close;
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
%DeltaR=10*cumsum(TableTest(:,3)-TableTest(:,4));
DeltaRCum=DeltaR;
for i=1:length(DeltaR)/length(DOYList)
    index=(1:length(DOYList))+(i-1)*length(DOYList);
    DeltaRCum(index)=cumsum(DeltaR(index));
end
DayEqualOpenGap=[Table(:,(1:4)) DeltaR DeltaRCum];
%DayEqualOpenGap=[Table(:,(1:4)) DeltaRCum];
%RBase=1;
DayMapforRSlopeASpect=zeros(length(RList)*length(SlopeList)*length(AspectList),5);
Row=0;
for R=RList
    for Slope=SlopeList
        for Aspect=AspectList 
            Row=Row+1;
            DayDeltaR=DayEqualOpenGap(DayEqualOpenGap(:,1)==R&DayEqualOpenGap(:,2)==Slope&DayEqualOpenGap(:,3)==Aspect,[4,5,6]);
            ichange=find(diff(sign(DayDeltaR(:,2)))==-2);
            if isempty(ichange)
                Day=999;
            else
                Day=-(DayDeltaR(ichange,1)-DayDeltaR(ichange+1,1))/ (DayDeltaR(ichange,2)-DayDeltaR(ichange+1,2))*DayDeltaR(ichange,2)+DayDeltaR(ichange,1);
            end
            
            ichange=find(diff(sign(DayDeltaR(:,3)))==-2);
            
            if isempty(ichange)
                DayCum=999;
            else
                DayCum=-(DayDeltaR(ichange,1)-DayDeltaR(ichange+1,1))/ (DayDeltaR(ichange,3)-DayDeltaR(ichange+1,3))*DayDeltaR(ichange,3)+DayDeltaR(ichange,1);
            end
            
            %             [Row ichange]
%             [Day DayDeltaR(ichange,1) DayDeltaR(ichange,2) DayDeltaR(ichange+1,1) DayDeltaR(ichange+1,2) ]
%DayCum
            DayMapforRSlopeASpect(Row,:)=[R, Slope, Aspect, Day(1), DayCum(1)];
        end
    end
    
end

RBase=2;
DayMapforSlopeASpect=zeros(length(SlopeList),length(AspectList));
DayCumMapforSlopeASpect=zeros(length(SlopeList),length(AspectList));

iSlope=0;

for Slope=SlopeList
    iSlope=iSlope+1;
    iAspect=0;
    for Aspect=AspectList 
       iAspect=iAspect+1;
       DayMapforSlopeASpect(iSlope,iAspect)= DayMapforRSlopeASpect(DayMapforRSlopeASpect(:,1)==RBase&DayMapforRSlopeASpect(:,2)==Slope&DayMapforRSlopeASpect(:,3)==Aspect,4);
       DayCumMapforSlopeASpect(iSlope,iAspect)= DayMapforRSlopeASpect(DayMapforRSlopeASpect(:,1)==RBase&DayMapforRSlopeASpect(:,2)==Slope&DayMapforRSlopeASpect(:,3)==Aspect,5);
       %[Slope Aspect DayMapforRSlopeASpect(DayMapforRSlopeASpect(:,1)==RBase&DayMapforRSlopeASpect(:,2)==Slope&DayMapforRSlopeASpect(:,3)==Aspect,4)]
    end
end

[Slope, Aspect]=meshgrid(SlopeList, AspectList);

%subplot(1,2,1),pcolor(Aspect ,Slope,DayMapforSlopeASpect'), xlabel('ASpect (\circ)'),ylabel('Slope (\circ)'),caxis([-10 180]);
%subplot(1,2,2),
%Ratio=10;
%uAspect=UpScale(Aspect, Ratio);
%uSlope=UpScale(Slope, Ratio);
%uDayCumMapforSlopeASpect=UpScale(DayCumMapforSlopeASpect, Ratio);
%uDayCumMapforSlopeASpect=smooth2(uDayCumMapforSlopeASpect, 100, 1);
%ch=pcolor(uAspect ,uSlope,uDayCumMapforSlopeASpect');

%DayCumMapforSlopeASpect_modified=DayCumMapforSlopeASpect;
%DayCumMapforSlopeASpect_modified(DayCumMapforSlopeASpect_modified==999)=MAX;
%DayCumMapforSlopeASpect_modified=DayCumMapforSlopeASpect_modified';
fontsize=20;
caxisrange=[80 180];

%[ch ch]=contourf(Aspect ,Slope,DayCumMapforSlopeASpect_modified);
[ch ch]=contourf(Aspect ,Slope,DayCumMapforSlopeASpect');
%[ch ch]=contourf([Aspect;-flipud(Aspect)] ,[Slope;flipud(Slope)],[DayCumMapforSlopeASpect_modified;flipud(DayCumMapforSlopeASpect_modified)]);
%ch=ContourPolar([Slope;flipud(Slope)],pi/180*[Aspect;-flipud(Aspect)] ,[DayCumMapforSlopeASpect_modified;flipud(DayCumMapforSlopeASpect_modified)]);
%[ch ch]=contourf([flipud(DayCumMapforSlopeASpect') ;DayCumMapforSlopeASpect']');
set(ch,'edgecolor','none');
set(ch,'LevelList',(min(caxisrange):(max(caxisrange)-min(caxisrange))/128:max(caxisrange)))
%set(ch,'ShowText','on')
xlabel('Aspect','fontsize',fontsize,'fontweight','b');
ylabel('Slope (\circ)','fontsize',fontsize,'fontweight','b');
%caxis([0 180]);
%MAX= ceil(max(max(DayCumMapforSlopeASpect(DayCumMapforSlopeASpect~=999))));
%MIN=floor(min(min(DayCumMapforSlopeASpect(DayCumMapforSlopeASpect~=999))));

%caxis([MIN min(MAX,170)]);
%caxis([10 175]);
caxis(caxisrange);
caxislabel=num2str((min(caxisrange):10:max(caxisrange)-10)');
caxislabel=[caxislabel repmat(' ',length(caxislabel),1) ];
caxislabel=[caxislabel;'N.A.'];
%caxislabel=num2str((min(caxisrange):20:max(caxisrange))');
colormapx=colormap(hot(128));
colormapx(end,:)=[1 1 1];
colormap(colormapx);
XTICK=[0 45 90 135 180];
XTICKLABEL={'South' 'Southeast' 'East' 'Northeast' 'North'};
set(gca,'XTick',XTICK,'XTickLabel',XTICKLABEL);
set(gca,'FontSize',fontsize-4)
h=colorbar;
 set(h,'XTickLabel',caxislabel);
 set(h,'FontSize',fontsize-8);
set(h,'location','northoutside');
print('-dpng',[Project '\DayEqual'],'-r400');
end