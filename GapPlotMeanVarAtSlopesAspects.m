function GapPlotMeanVarAtSlopesAspects(H,HeightMap,R,Project)
close all;
if nargin==0
	H=25;
    R=2;
    Project='.';
end
Row=0;
SlopeList=(0:15:45);
AspectList=(0:45:180);
Site=GapForestSite(Project);

Output=zeros(length(SlopeList)*length(AspectList),32);

for Slope=SlopeList
    for Aspect=AspectList
        Row=Row+1;
        Progress=[num2str(quant(Row/(length(SlopeList)*length(AspectList))*100,.1)) ' %'];
        disp(Progress);
        [meanNet meanLNet meanSNet Net LNet SNet rTransect r w varNet varLNet varSNet ]=GapModel(H,HeightMap,R,Slope,Aspect,Site,1);
        %Output(Row,:)=[Slope Aspect meanNet(1) meanLNet(1) meanSNet(1) varNet(1) varLNet(1) varSNet(1) meanNet(2) meanLNet(2) meanSNet(2) varNet(2) varLNet(2) varSNet(2) meanNet(3) meanLNet(3) meanSNet(3) varNet(3) varLNet(3) varSNet(3) meanNet(4) meanLNet(4) meanSNet(4) varNet(4) varLNet(4) varSNet(4) meanNet(5) meanLNet(5) meanSNet(5) varNet(5) varLNet(5) varSNet(5)];
        Output(Row,:)=[Slope Aspect meanNet meanLNet meanSNet varNet varLNet varSNet];
    end    
end

save([Project '\MeanVarAtSlopesAspects'],'R','Project','Output');
%load('NorthSouthWestEastAtSlopesAspects.mat');
[Slope Aspect]=meshgrid(unique(Output(:,1)),unique(Output(:,2)));
Zeros=zeros(size(Slope,1),size(Slope,2),5);

mNet=Zeros;
mLNet=Zeros;
mSNet=Zeros;

vNet=Zeros;
vLNet=Zeros;
vSNet=Zeros;

Counter=0;
for i=1:size(Slope,2)
    for j=1:size(Slope,1)
        Counter=Counter+1;

        mNet(j,i,:)=Output(Counter,(3:7));
        mLNet(j,i,:)=Output(Counter,(8:12));
        mSNet(j,i,:)=Output(Counter,(13:17));

        vNet(j,i,:)=Output(Counter,(18:22));
        vLNet(j,i,:)=Output(Counter,(23:27));
        vSNet(j,i,:)=Output(Counter,(28:32));

    end
end
LevelList=(-1000:10:1000);
LevelList2=(-1000:2:1000);
figure(1)
subplot(2,4,[1,2]),[C h]=contourf(Aspect,Slope,mSNet(:,:,1),10);title('mSNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
subplot(2,4,[3,4]),[C h]=contourf(Aspect,Slope,mLNet(:,:,1),10);title('mLNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList2);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
subplot(2,4,[6,7]),[C h]=contourf(Aspect,Slope,mNet(:,:,1),10);title('mNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
print('-dpng',[Project '\MeanSlopeAspect R=' num2str(R,'%.1f') '.png'],'-r600');
figure(2)
subplot(2,4,[1,2]),[C h]=contourf(Aspect,Slope,vSNet(:,:,1),10);title('vSNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
subplot(2,4,[3,4]),[C h]=contourf(Aspect,Slope,vLNet(:,:,1),10);title('vLNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
subplot(2,4,[6,7]),[C h]=contourf(Aspect,Slope,vNet(:,:,1),10);title('vNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
print('-dpng',[Project '\VarSlopeAspect R=' num2str(R,'%.1f') '.png'],'-r600');

% figure(1)
% subplot(2,3,1),[C h]=contourf(Aspect,Slope,mNet(:,:,1),10);title('mNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,2),[C h]=contourf(Aspect,Slope,mLNet(:,:,1),10);title('mLNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList2);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,3),[C h]=contourf(Aspect,Slope,mSNet(:,:,1),10);title('mSNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,4),[C h]=contourf(Aspect,Slope,vNet(:,:,1),10);title('vNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,5),[C h]=contourf(Aspect,Slope,vLNet(:,:,1),10);title('vLNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,6),[C h]=contourf(Aspect,Slope,vSNet(:,:,1),10);title('vSNet (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);

% figure(2)
% subplot(2,3,1),[C h]=contourf(Aspect,Slope,mNet(:,:,2),10);title('mNetNorth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,2),[C h]=contourf(Aspect,Slope,mLNet(:,:,2),10);title('mLNetNorth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList2);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,3),[C h]=contourf(Aspect,Slope,mSNet(:,:,2),10);title('mSNetNorth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,4),[C h]=contourf(Aspect,Slope,vNet(:,:,2),10);title('vNetNorth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,5),[C h]=contourf(Aspect,Slope,vLNet(:,:,2),10);title('vLNetNorth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,6),[C h]=contourf(Aspect,Slope,vSNet(:,:,2),10);title('vSNetNorth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% 
% figure(3)
% subplot(2,3,1),[C h]=contourf(Aspect,Slope,mNet(:,:,3),10);title('mNetSouth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,2),[C h]=contourf(Aspect,Slope,mLNet(:,:,3),10);title('mLNetSouth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList2);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,3),[C h]=contourf(Aspect,Slope,mSNet(:,:,3),10);title('mSNetSouth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,4),[C h]=contourf(Aspect,Slope,vNet(:,:,3),10);title('vNetSouth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,5),[C h]=contourf(Aspect,Slope,vLNet(:,:,3),10);title('vLNetSouth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,6),[C h]=contourf(Aspect,Slope,vSNet(:,:,3),10);title('vSNetSouth (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% 
% figure(4)
% subplot(2,3,1),[C h]=contourf(Aspect,Slope,mNet(:,:,4),10);title('mNetWest (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,2),[C h]=contourf(Aspect,Slope,mLNet(:,:,4),10);title('mLNetWest (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList2);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,3),[C h]=contourf(Aspect,Slope,mSNet(:,:,4),10);title('mSNetWest (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,4),[C h]=contourf(Aspect,Slope,vNet(:,:,4),10);title('vNetWest (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,5),[C h]=contourf(Aspect,Slope,vLNet(:,:,4),10);title('vLNetWest (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,6),[C h]=contourf(Aspect,Slope,vSNet(:,:,4),10);title('vSNetWest (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% 
% figure(5)
% subplot(2,3,1),[C h]=contourf(Aspect,Slope,mNet(:,:,5),10);title('mNetEast (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,2),[C h]=contourf(Aspect,Slope,mLNet(:,:,5),10);title('mLNetEast (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList2);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,3),[C h]=contourf(Aspect,Slope,mSNet(:,:,5),10);title('mSNetEast (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,4),[C h]=contourf(Aspect,Slope,vNet(:,:,5),10);title('vNetEast (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,5),[C h]=contourf(Aspect,Slope,vLNet(:,:,5),10);title('vLNetEast (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
% subplot(2,3,6),[C h]=contourf(Aspect,Slope,vSNet(:,:,5),10);title('vSNetEast (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);

%print('-dpng',[Project '\NorthSouthEastWest R=' num2str(R,'%.1f') '.png'],'-r600');
end