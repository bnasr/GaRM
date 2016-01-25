function Table=GapTableAllSizeSlopeAspects(Project,H)

RList=[0.1 0.2 0.5 1 2 5 10 100];
SlopeList=(0:2:45);
AspectList=(0:5:180);
TotalSize=(size(RList,2)*size(SlopeList,2)*size(AspectList,2));
Table=zeros(TotalSize,6);
Row=0;

for i=1:(size(RList,2))
    for j=1:(size(SlopeList,2))
        for k=1:(size(AspectList,2))
            [Net Lnet Snet]=GapModel(H,RList(i),SlopeList(j),AspectList(k),Project,1);
            Row=Row+1;
            Table(Row,:)=[RList(i) SlopeList(j) AspectList(k) Net Lnet Snet];
            Progress=Row/TotalSize*100;
            fprintf('Progress... %d of %d : %.3f%%\n',Row, TotalSize,Progress);
        end
    end
end


end