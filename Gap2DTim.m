function Gap2DTim
DH=1;

Vfgap=2/pi*atan(DH/2);
td=0.215;
ta=0.8;
eair=0.72;
ecca=0.98;
Ta=0+273.15;
Tc=Ta;
sigma=5.67e-8;
miu=0.2;

Sbf=(1-fd)*ta*So*cosd(zenith)*exp(-H*miu/cosd(zenith));
Sdf= fd*ta*So*cosd(zentih)*(Vfgap+td*(1-Vfgap));

Lo=eair*sigma*Ta^4;
Lc=ecan*sigma*Tc^4;
Lf=(Lc-Lo)*(1-td)*(1-Vfgap)+Lo;


end