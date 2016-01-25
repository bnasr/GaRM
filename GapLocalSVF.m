function SVF=GapLocalSVF(R,r,Omega,Slope)
SVF=zeros(size(r));
theta=(0:pi/100:2*pi)';
for i=1:size(r,1)
    for j=1:size(r,2)
        dSlope=FoRMDirectionalSlope(Slope,theta);
%        L=-r(i,j)*cos(Omega(i,j)-Phi)+sqrt(R^2+(r(i,j)*cos(Omega(i,j)-Phi)).^2-r(i,j)^2);
        L=-r(i,j)*cos(Omega(i,j)-theta)+sqrt(R^2-(r(i,j)*sin(Omega(i,j)-theta)).^2);
        Gamma=atan(L.*cos(dSlope)./(1+L.*sin(dSlope)));
        SVF(i,j)=trapz(theta,(Gamma+pi*(Gamma<0)))/(pi*pi);
    end
end
end