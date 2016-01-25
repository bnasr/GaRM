function GapPercentageBelowOpenColorMap(Table, R,DOY)
FilteredTable=Table(Table(:,1)==R&Table(:,4)==DOY,:);

[Slope Aspect]=meshgrid(unique(FilteredTable(:,2)),unique(FilteredTable(:,3)));
Zeros=zeros(size(Slope,1),size(Slope,2),2);

map=Zeros;

Counter=0;
for i=1:size(Slope,2)
    for j=1:size(Slope,1)
        Counter=Counter+1;

        map(j,i,:)=FilteredTable(Counter,(5:6));
    end
end
TITLE=['Area with R<R_o_p_e_n (%) for R=' num2str(R) ' at Day ' num2str(DOY)];

LevelList=(0:10:100);
%subplot(2,1,1),

[C h]=contourf(Aspect,Slope,map(:,:,1),10);title(TITLE,'fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
%subplot(2,1,2),[C h]=contourf(Aspect,Slope,map(:,:,2),10);title('Area with R<R_o_p_e_n (%)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (^\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);set(h,'LevelList',LevelList);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);


end