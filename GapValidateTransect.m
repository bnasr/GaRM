function [Sin Lin]=GapValidateTransect(Site,H,HeightMap,R,Slope, Aspect)
NR=Site.NR;
Nw=Site.NW;

[meanNet meanLnet meanSnet Net Lnet Snet rTransect r w varNet varLnet varSnet Sincom Lincom meanSincom meanLincom]=GapModel(H,HeightMap,R,Slope,Aspect,Site,1);

Sin=[meanSincom Sincom(1,NR:-1:2) Sincom(ceil(Nw/2)+1,:)];
Lin=[meanLincom Lincom(1,NR:-1:2) Lincom(ceil(Nw/2)+1,:)];

end