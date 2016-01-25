function [L x dSlope]=GapPathLength(r,w,Theta,Phi,R,Slope,Aspect)
%Phi=-Phi;
%L=max(0,min(cos(Slope)/cos(Theta),cos(Slope)/cos(Theta)-cos(dSlope)/sin(dSlope+Theta).*((-r.*cos(Phi-Aspect-w)+sqrt(R^2-(r.*sin(Phi-Aspect-w)).^2)))));
%dSlope=FoRMDirectionalSlope(Slope,Phi-Aspect);


%Gamma=Phi-Aspect;
Gamma=atan(cos(Slope)*tan(Phi-Aspect));
Gamma=Gamma+pi/2*(floor(Gamma/(pi/2))-floor((Phi-Aspect)/(pi/2)));

dSlope=FoRMDirectionalSlope(Slope,Gamma);
x=((-r.*cos(Gamma-w)+sqrt(R^2-(r.*sin(Gamma-w)).^2)));
L=max(0,min(cos(dSlope)/cos(Theta+dSlope),cos(dSlope)/cos(Theta+dSlope)-cos(dSlope)/sin(Theta).*x));
end