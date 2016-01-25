function CVF=GapLocalCVFDirectional(R,r,Omega,Slope,NW)

theta=(0:2*pi/NW:2*pi)';
CVF=zeros(length(theta),size(r,1),size(r,2));

for i=1:size(r,1)
    for j=1:size(r,2)
        dSlope=FoRMDirectionalSlope(Slope,theta);
%        L=-r(i,j)*cos(Omega(i,j)-Phi)+sqrt(R^2+(r(i,j)*cos(Omega(i,j)-Phi)).^2-r(i,j)^2);
        L=-r(i,j)*cos(Omega(i,j)-theta)+sqrt(R^2-(r(i,j)*sin(Omega(i,j)-theta)).^2);
        Gamma=atan((1+L.*sin(dSlope))./(L.*cos(dSlope)))-dSlope;
        %CVF(:,i,j)=(Gamma+pi*(Gamma<0))/(0.5*pi);
        CVF(:,i,j)=(Gamma+pi*(Gamma<0))/(0.5*pi);
        %CVF(:,i,j)=(Gamma);
        %CVF(:,i,j)=(Gamma+pi*(Gamma<0))*180/pi;
    end
end
end