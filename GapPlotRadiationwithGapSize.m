function GapPlotRadiationwithGapSize(Slope, Phis,Site)
if nargin==2
    Site=GapModel('Greenville',45.46,-69.58,423,4.9568,28.3324,9.1677,217.8418,4);
end
i=0;
%RList=[0.1 0.2 0.35 .7 1 2 5 10 20 50 100];
%RList=roundn(10.^(-1:.2:2),-1);
%RList=10.^(1:1:2);
RList=[0.1 0.2 0.5 1 2 5 10 20 50 100];
RList=[1  ];

for R=RList;
    i=i+1;
    Progress=i/size(RList,2)*100;
    [Net(i) Lnet(i) Snet(i)]=GapModel(R,Slope,Phis,Site,1);
    fprintf('%s: Progress... %.f%%\n',char(Site.Name),Progress);
end
legends={'Net','L_n_e_t','S_n_e_t'};
%PlotCurveListLegendSTR([Net' Lnet' Snet'],legends,log10(RList'),'log R/H','Radiation W/m^2',['FGR at ' char(Site.Name)],strcat(Site.Name, '.png'),20,0,'NorthEast','auto','auto');
PlotCurveListLegendSTR([Net' Lnet' Snet'],legends,log10(RList'),'R/H','Radiation W/m^2',['FGR at ' char(Site.Name)],strcat(Site.Name, '.png'),20,0,'NorthEast','auto','auto',log10(RList'),RList);
%PlotCurveListLegendSTR([Net' Lnet' Snet'],legends,(RList'),' R/H','Radiation W/m^2',strcat('FGR @ ', Site.Name),strcat(Site.Name, '-.png'),20,0,'NorthEast','auto','auto')

end