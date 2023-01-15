clc;
clear all;
close all;

load('../alldata.mat');




c_map = brewermap(9, 'BrBG');
%c_map = brewermap(9, 'PuOr');
scene_names = dir('../results/GCAM-ssp434.mat');
 scene_name = 'Difference in forest and crop (basemap)';
    
    res_v = 0.25;
    res_h = 0.25;
    lon = (-180+res_h/2):res_h: (180-res_h/2);
    lat = (90-res_v/2):-res_v: (-90 + res_v/2);
    [lons,lats]=meshgrid(lon,lat);
    
    
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.80,0.7]);
    subplot('Position', [0.04 0.53 0.42 0.4]);
    
    % plot_global_map(lats, lons, trend_LAI./mean_LAI, -0.02, 0.02, "LAI", c_map);
    A = LAI_forest_values>LAI_crop_values;
    C = EVI_forest_values<EVI_crop_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI>0 & EVI<0", c_map);
    
    subplot( 'Position', [0.52 0.53 0.42 0.4]);
    % plot_global_map(lats, lons, trend_EVI./mean_EVI, -0.02, 0.02, "EVI", c_map);
    
    A = LAI_forest_values>LAI_crop_values;
    C = EVI_forest_values>EVI_crop_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI>0 & EVI>0", c_map);

        
    subplot( 'Position', [0.04 0.05 0.42 0.4]);
    
    A = LAI_forest_values<LAI_crop_values;
    C = EVI_forest_values>EVI_crop_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI<0 & EVI>0", c_map);

    
        subplot( 'Position', [0.52 0.05 0.42 0.4]);
    
    A = LAI_forest_values<LAI_crop_values;
    C = EVI_forest_values<EVI_crop_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI<0 & EVI<0", c_map);

    %plot_global_map(lats, lons, trend_LAI./mean_LAI - trend_EVI./mean_EVI, -0.02, 0.02, "Difference", c_map);
    
    
    suptitle(scene_name)
    print(gcf, '-dtiff', '-r300', ['figures/basemap_difference.tif'])
    close all

    
    
    clc;
clear all;
close all;

load('../alldata.mat');




c_map = brewermap(9, 'BrBG');
%c_map = brewermap(9, 'PuOr');
scene_names = dir('../results/GCAM-ssp434.mat');
 scene_name = 'Difference in forest and grass (basemap)';
    
    res_v = 0.25;
    res_h = 0.25;
    lon = (-180+res_h/2):res_h: (180-res_h/2);
    lat = (90-res_v/2):-res_v: (-90 + res_v/2);
    [lons,lats]=meshgrid(lon,lat);
    
    
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.80,0.7]);
    subplot('Position', [0.04 0.53 0.42 0.4]);
    
    % plot_global_map(lats, lons, trend_LAI./mean_LAI, -0.02, 0.02, "LAI", c_map);
    A = LAI_forest_values>LAI_grass_values;
    C = EVI_forest_values<EVI_grass_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI>0 & EVI<0", c_map);
    
    subplot( 'Position', [0.52 0.53 0.42 0.4]);
    % plot_global_map(lats, lons, trend_EVI./mean_EVI, -0.02, 0.02, "EVI", c_map);
    
    A = LAI_forest_values>LAI_grass_values;
    C = EVI_forest_values>EVI_grass_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI>0 & EVI>0", c_map);

        
    subplot( 'Position', [0.04 0.05 0.42 0.4]);
    
    A = LAI_forest_values<LAI_grass_values;
    C = EVI_forest_values>EVI_grass_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI<0 & EVI>0", c_map);

    
        subplot( 'Position', [0.52 0.05 0.42 0.4]);
    
    A = LAI_forest_values<LAI_grass_values;
    C = EVI_forest_values<EVI_grass_values;
    D = A.*(C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI<0 & EVI<0", c_map);

    %plot_global_map(lats, lons, trend_LAI./mean_LAI - trend_EVI./mean_EVI, -0.02, 0.02, "Difference", c_map);
    
    
    suptitle(scene_name)
    print(gcf, '-dtiff', '-r300', ['figures/basemap_difference_grass.tif'])
    close all


