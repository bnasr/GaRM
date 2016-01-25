classdef GapForestSite
    properties
        Name
        Latitude
        Longitude
        Longitude_std
        DLS
        Elevation
        T_m
        T_yrange
        T_drange
        T_phase
        Miu
        eCLD
        eCLR
        kb_kD
        SKYCOVER
        tDIF
        tDIR
        eCan
        eSky
        eSnow
        DOY_start
        DOY_end
        NW
        NR
        albedo_dir
        albedo_dif
        albedo_canopy
        RH
        CLEAR_CLOUDY
        delTc_t
        delTc_ins
        delTair
        eSkyRatio
        albedo_temporal_exists
        albedo_temporal
    end
    
    methods
        function obj = GapForestSite(folder)
            obj.eCLD=load([folder '\eCLD']);
            obj.eCLR=load([folder '\eCLR']);
            obj.tDIF=load([folder '\tDIF']);
            obj.tDIR=load([folder '\tDIR']);
            obj.SKYCOVER=load([folder '\SKYCOVER']);
            obj.Name=folder;
            geo=load([folder '\geo.txt']);
            climate=load([folder '\climate.txt']);
            model=load([folder '\model.txt']);
            obj.Latitude=geo(1);
            obj.Longitude=geo(2);
            obj.Longitude_std=geo(3);
            obj.DLS=geo(5);
            obj.Elevation=geo(4);
            obj.T_m=climate(1);
            obj.T_yrange=climate(2);
            obj.T_drange=climate(3);
            obj.T_phase=climate(4);            
            obj.DOY_start=model(1);
            obj.DOY_end=model(2);
            obj.NR=model(3);
            obj.NW=model(4);
            obj.Miu=model(5);
            obj.eCan=model(6);
            obj.eSnow=model(7);
            obj.albedo_dir=model(8);
            obj.albedo_dif=model(9);
            obj.CLEAR_CLOUDY=model(10);
            obj.albedo_canopy=model(11);
            obj.delTc_t=model(12);
            obj.delTc_ins=model(13);
            obj.delTair=model(14);
            obj.eSkyRatio=model(15);
            
            obj.kb_kD=load([folder '\kb_kD']);
            obj.RH=load([folder '\RH']);
            if obj.CLEAR_CLOUDY==0
                obj.eSky=obj.eCLR;
            else
                obj.eSky=obj.eCLD;
            end
            obj.eSky=obj.eSky*obj.eSkyRatio;
            
            if(exist([folder '\albedo']))
                obj.albedo_temporal_exists=1;
                obj.albedo_temporal=load([folder '\albedo']);
            else
                obj.albedo_temporal_exists=0;
            end
        end
    end
    
end

