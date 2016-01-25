function [Lnet Lcan Lsky Lsnow]=GapLocalLnet(R,Slope,DOY,r,w,TM,YR,DR,Phase)
if nargin==5
    TM=5;
    YR=30;
    DR=10;
    Phase=210;
end

eCan=0.99;
eSky=0.7;
eSnow=0.99;

StephanBoltzman=5.67e-8;

SVF = GapLocalSVF(R,r,w,Slope/180*pi);
[Tair Tsnow]=GapTemperature(DOY,TM+273.15,YR,DR,Phase);

Lcan=StephanBoltzman*eCan*mean(Tair.^4)*(1-SVF);
Lsky=StephanBoltzman*eSky*mean(Tair.^4)*SVF;
Lsnow=StephanBoltzman*eSnow*mean(Tsnow.^4);
Lnet=Lcan+Lsky-Lsnow;

end