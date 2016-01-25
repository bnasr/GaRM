classdef GapSolar
   properties
      Alpha
      Delta
      DayLength
      Phi
      Theta
      
      Sopen
      Sdiropen
      Sdifopen
      SdiropenAVG
      SdifopenAVG
   end
   methods
      function obj = GapSolar(DOY1, Slope, Phis, Site)
        DOY=mod(DOY1+365,365);
        L=Site.Latitude;

        B = (DOY - 81)*360/365;
        ET = 9.87*sind(2*B)- 7.53*cosd(B)-1.5*sind(B);
        obj.Delta=  23.45*sind(360/365 * (284 + DOY) );
        LST = mod(DOY*24*60, 24*60);
        AST = LST + ET + 4* (Site.Longitude_std - Site.Longitude) - Site.DLS ;
        HourAngle = (AST - 12*60)/4;
        obj.Alpha =  asind(sind(L).*sind(obj.Delta)+ cosd(L).*cosd(obj.Delta).*cosd(HourAngle));
        Hss = acosd(-tand(L).*tand(obj.Delta))/15;
        Hsr = -acosd(-tand(L).* tand(obj.Delta))/15;
        obj.DayLength = Hss - Hsr;
        Phi1 = asind(cosd(obj.Delta).*sind(HourAngle)./cosd(obj.Alpha));
        
        if (AST < 12*60) 
            Phi2=-180 + abs(Phi1);
        else
            Phi2=180 - Phi1;
        end
        
        if (cosd(HourAngle)> tand(obj.Delta)/tand(L))
            obj.Phi = Phi1;
        else
            obj.Phi = Phi2;
        end
        obj.Theta = min(90,acosd(sind(L).*sind(obj.Delta).*cosd(Slope)- cosd(L).*sind(obj.Delta).* sind(Slope).* cosd(Phis)+ cosd(L).*cosd(obj.Delta).* cosd(HourAngle).*cosd(Slope)+         sind(L).*cosd(obj.Delta).* cosd(HourAngle).*sind(Slope).*cosd(Phis)+cosd(obj.Delta).*sind(HourAngle).*sind(Slope).*sind(Phis)));

        Sc=1366.1;
        Sextr=Sc*(1+0.033*cosd(360*DOY./365));
        if Site.CLEAR_CLOUDY==0
            a0=0.4237-0.00821*(6-Site.Elevation/1000.0)^2;
            a1=0.5055+0.00595*(6.5-Site.Elevation/1000.0)^2;
            k=0.2711+0.01858*(2.5-Site.Elevation/1000.0)^2;
            tb=a0+a1*exp(-k./sind(obj.Alpha));
            td=Site.kb_kD(1)*tb+Site.kb_kD(2);
        else
            index=mod(ceil(DOY),365)+1;
            tb=Site.tDIR(index);
            td=Site.tDIF(index);
        end
        
        %SextrNormal=Sextr.*cosd(obj.Theta);
        obj.Sdiropen=tb.*Sextr.*cosd(obj.Theta);
        obj.Sdifopen=td.*Sextr.*sind(obj.Alpha).*(cosd(Slope/2.)).^2;


        %AlphaAVG=sum(obj.Alpha)/max(size(obj.Alpha));
        %ThetaAVG=sum(obj.Theta)/max(size(obj.Theta));
        %obj.SdiropenAVG=sum(obj.Sdiropen)/max(size(obj.Sdiropen));
        %obj.SdifopenAVG=sum(obj.Sdifopen)/max(size(obj.Sdifopen));

      end
   end
end