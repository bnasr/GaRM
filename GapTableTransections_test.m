function [Net RList]=GapTableTransections_test
Project='.';

Site=GapForestSite(Project);


NR=Site.NR;
Nw=Site.NW;

H=25;
RList=[0.1 0.2 0.5 1 2 5 10 20 50 100];
SlopeList=(0:0);
AspectList=(0:0);

LnetTable=zeros(size(RList,2)*size(SlopeList,2)*size(AspectList,2),2*NR-1+6);
SnetTable=zeros(size(RList,2)*size(SlopeList,2)*size(AspectList,2),2*NR-1+6);
NetTable=zeros(size(RList,2)*size(SlopeList,2)*size(AspectList,2),2*NR-1+6);

Row=0;

for i=1:(size(RList,2))
    for k=1:(size(AspectList,2))
        for j=1:(size(SlopeList,2))
            Row=Row+1;
            [meanNet meanLnet meanSnet Net Lnet Snet rTransect]=GapModel(H,RList(i),SlopeList(j),AspectList(k),Project,1);
            NetTable(Row,7:2*NR-1+6)=[Net(1,NR:-1:2) Net(ceil(Nw/2)+1,:)];
            SnetTable(Row,7:2*NR-1+6)=[Snet(1,NR:-1:2) Snet(ceil(Nw/2)+1,:)];
            LnetTable(Row,7:2*NR-1+6)=[Lnet(1,NR:-1:2) Lnet(ceil(Nw/2)+1,:)];
            
            NetTable(Row,1:6)=[RList(i) SlopeList(j) AspectList(k) meanNet(1) meanLnet(1) meanSnet(1) ];
            SnetTable(Row,1:6)=[RList(i) SlopeList(j) AspectList(k) meanNet(1) meanLnet(1) meanSnet(1) ];
            LnetTable(Row,1:6)=[RList(i) SlopeList(j) AspectList(k) meanNet(1) meanLnet(1) meanSnet(1) ];
            
            Progress=floor(Row/(size(RList,2)*size(SlopeList,2)*size(AspectList,2))*100);
            fprintf('Progress... %.f%%\n',Progress);

        end
    end
end
rTransect=rTransect/RList(size(RList,2));
%Net=NetTable(:,(4:6));
Net=NetTable(:,4);
close
plot(log(RList),Net)
xlabel('R (m)');
ylabel('Net (W/m^2)');
%legend({'Net','L_N_e_t','S_N_e_t'});
save('R_N','RList','Net');
set(gca,'XTickLabel',RList)
print('-dpng',[Project '\R_and_Net.png']);

end