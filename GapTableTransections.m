function [rTransect NetTable LnetTable SnetTable]=GapTableTransections(H,HeightMap,Project)
Site=GapForestSite(Project);


NR=Site.NR;
Nw=Site.NW;

DList=[0.1 0.2 0.5 1 2 5 10 20 50 100];
DList=[0.1 0.2 0.5 1 2 5 10 20];
RList=DList/2;
SlopeList=(0:15:45);
AspectList=(0:45:180);

LnetTable=zeros(size(RList,2)*size(SlopeList,2)*size(AspectList,2),2*NR-1+6);
SnetTable=zeros(size(RList,2)*size(SlopeList,2)*size(AspectList,2),2*NR-1+6);
NetTable=zeros(size(RList,2)*size(SlopeList,2)*size(AspectList,2),2*NR-1+6);

Row=0;

for i=1:(size(RList,2))
    for j=1:(size(SlopeList,2))
        dr=RList(i)/Site.NR;
        dw=2*pi/Site.NW;
        %[r,w] = meshgrid(dr/2:dr:RList(i)-dr/2,0:dw:2*pi);
        [r,w] = meshgrid(0:dr:RList(i)-dr,0:dw:2*pi);
        SVF = GapLocalSVF(RList(i),r,w,SlopeList(j)/180*pi);

        for k=1:(size(AspectList,2))
            Row=Row+1;
            [meanNet meanLnet meanSnet Net Lnet Snet rTransect]=GapModel(H,HeightMap,RList(i),SlopeList(j),AspectList(k),Site,1,SVF);
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
end