function [ Height Theta SVF]=TreeHeightFromSkyMap(imfile,D,nTheta,level,plotoff)
if nargin==0
    imfile='SVF.png';
    D=60;
    nTheta=200;
    plotoff=0;
    level=0.2;
end

close    
im=imread(imfile);
BW = im2bw(im, level);
center=ceil(size(BW)/2);
R_nopixel=center(1)-1;


itheta=0;
altitude=zeros(nTheta,1);
Theta=(0:360/nTheta:360);

 SVF=0;
% N=(R_nopixel+1)*nTheta;
% for theta=Theta(2:end)
%     for Elevation=0:R_nopixel
%         x=center(1)+Elevation*cosd(theta);
%         y=center(2)+Elevation*sind(theta);
%         if BW(floor(x),floor(y))
%             SVF=SVF+1/N;
%         end
%     end    
% end

for theta=Theta
    itheta=itheta+1;
    edge=center+floor(R_nopixel*[cosd(theta) sind(theta)]);
    if abs(center(1)-edge(1))>=abs(center(2)-edge(2))
        sgn=-sign(center(1)-edge(1));
        direction_row=(center(1):sgn:edge(1))';
        direction_column=ceil(interp1([center(1) edge(1)],[center(2) edge(2)],direction_row));
    else
        sgn=-sign(center(2)-edge(2));
        direction_column=(center(2):sgn:edge(2))';
        direction_row=ceil(interp1([center(2) edge(2)],[center(1) edge(1)],direction_column));
    end
    index= sub2ind(size(BW), direction_row, direction_column);
    direction=BW(index);
    altitude(itheta)=90*find(direction==0, 1 )/(length(direction)+1);
end
altitude=90-altitude;
Height=tand(altitude)*D/2;

if plotoff==0
    subplot(2,3,1),imshow(im)
    hold on
    circle(center(1),center(2),R_nopixel/2,'r')
    circle(center(1),center(2),R_nopixel,'g')

    subplot(2,3,2),imshow(BW)
    hold on
    circle(center(1),center(2),R_nopixel/2,'r')
    circle(center(1),center(2),R_nopixel,'g')

    subplot(2,3,3),
    polar((Theta-90)'/180*pi,90-altitude)

    subplot(2,3,[4 6]),
    %plot(Theta,[altitude 45*ones(size(Theta'))])
    %plot(Theta,Height,'g')
    area(Theta,Height,'facecolor',[0 .5 0])
    axis([0 360 0 ceil(max(Height)/5)*5]);
end
Theta=Theta';
end