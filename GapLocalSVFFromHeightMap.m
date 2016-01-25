function SVF=GapLocalSVFFromHeightMap(H,HeightMap,R,r,Omega,Slope)

SVF=zeros(size(r));
Phi=(0:pi/100:2*pi)';
thetamap=HeightMap(:,1)*pi/180;
for i=1:size(r,1)
    for j=1:size(r,2)
        if i==2&&j==1
        end
        
        nom=R*sin(thetamap)-r(i,j)*sin(Omega(i,j));
        denom=R*cos(thetamap)-r(i,j)*cos(Omega(i,j));
        rhomap=atan(nom./denom)+pi*(denom<0)+2*pi*(denom>0&nom<0);
        hmap=HeightMap(:,2)/H;

        [U, Index]=unique(rhomap,'rows');
        
        DupIndex=setdiff(1:size(rhomap,1),Index);
        rhomap(DupIndex,:)=[];
        hmap(DupIndex,:)=[];
        heightmap=interp1(rhomap,hmap,Phi);
        [vmin imin]=min(rhomap);
        [vmax imax]=max(rhomap);
        if isnan(min(heightmap))
        end
        heightmap(Phi<vmin)=hmap(imin);
        heightmap(Phi>vmax)=hmap(imax);
        dSlope=FoRMDirectionalSlope(Slope,Phi);
        L=-r(i,j)*cos(Omega(i,j)-Phi)+sqrt((r(i,j)*cos(Omega(i,j)-Phi)).^2-r(i,j)^2+R^2);
        Gamma=atan(L.*cos(dSlope)./(heightmap.*(1+L.*sin(dSlope))));
        SVF(i,j)=trapz(Phi,(Gamma+pi*(Gamma<0)))/(pi*pi);
    end
end
end