function GapPlotAllSizeSlopeAspects(Project,Table,R)
data=Table(Table(:,1)==R,2:6);
[Slope Aspect]=meshgrid(unique(data(:,1)),unique(data(:,2)));
Net=zeros(size(Slope));
Lnet=zeros(size(Slope));
Snet=zeros(size(Slope));
Counter=0;
for i=1:size(Slope,2)
    for j=1:size(Slope,1)
        Counter=Counter+1;
        Net(j,i)=data(Counter,3);
        Lnet(j,i)=data(Counter,4);
        Snet(j,i)=data(Counter,5);
    end
end
subplot(2,4,[1 2]),[C h]=contourf(Aspect,Slope,Snet,10);title('S_N_e_t (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);%set(ch,'edgecolor','none'),colorbar%,caxis([30 120]);
subplot(2,4,[3 4]),[C h]=contourf(Aspect,Slope,Lnet,10);title('L_N_e_t (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),xlabel('Aspect (\circ)','fontweight','b');NewClabel(C,h);%set(ch,'edgecolor','none'),colorbar,colormap jet%,caxis([30 120]);
subplot(2,4,[6 7]),[C h]=contourf(Aspect,Slope,Net,10);title('Net (W/m^2)','fontweight','b');set(gca,'XTick', (0:30:180)),set(gca,'YTick', (0:15:45)),ylabel('Slope (\circ)','fontweight','b'),xlabel('Aspect (^\circ)','fontweight','b');NewClabel(C,h);%set(ch,'edgecolor','none'),colorbar,colormap jet%,caxis([30 120]);
colormap jet;
print('-dpng',[Project '\All slope and aspects for R=' num2str(R,'%.1f') '.png'],'-r600');
end