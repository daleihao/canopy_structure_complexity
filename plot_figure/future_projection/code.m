
c_map = brewermap(9, 'BrBG');
%c_map = brewermap(9, 'PuOr');
scene_names = dir('../results/GCAM-ssp434.mat');
count = size(scene_names, 1);
for i = 1:count
    
    scene_name = scene_names(i).name;
    scene_name = scene_name(1:end-4);
    load( ['../results/' scene_names(i).name]);
    filters = H_EVI<1 | sig_EVI>=0.05;
    trend_EVI(filters) = nan;
    filters = H_LAI<1 | sig_LAI>=0.05;
    trend_LAI(filters) = nan;
    
    
    res_v = 0.25;
    res_h = 0.25;
    lon = (-180+res_h/2):res_h: (180-res_h/2);
    lat = (90-res_v/2):-res_v: (-90 + res_v/2);
    [lons,lats]=meshgrid(lon,lat);
    
    
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.80,0.7]);
    subplot('Position', [0.04 0.53 0.42 0.4]);
    
    % plot_global_map(lats, lons, trend_LAI./mean_LAI, -0.02, 0.02, "LAI", c_map);
    A = trend_LAI>0;
    B = isnan(trend_EVI);
    C = trend_EVI<0;
    D = A.*(B | C);
    D(D<=0) = nan;
    D = D.*(trend_EVI./mean_EVI - );
    plot_global_map(lats, lons, D, 0, 1, "LAI>0 & (EVI<0 or not significant)", c_map);
    
    subplot( 'Position', [0.52 0.53 0.42 0.4]);
    % plot_global_map(lats, lons, trend_EVI./mean_EVI, -0.02, 0.02, "EVI", c_map);
    
    A = trend_LAI>0;
    C = trend_EVI>0;
    D = A.*C;
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI>0 & EVI>0", c_map);

    
%     hcb = colorbar;
%     
%     x=get(hcb,'Position');
%     x(3)=0.02;
%     x(1)=0.935;
%     x(4)=0.8;
%     x(2)=0.08;
%     set(hcb,'Position',x)
    
    subplot( 'Position', [0.04 0.05 0.42 0.4]);
    
        A = trend_LAI<0;
    B = isnan(trend_EVI);
    C = trend_EVI>0;
    D = A.*(B | C);
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI<0 & (EVI>0 or not significant)", c_map);

    
        subplot( 'Position', [0.52 0.05 0.42 0.4]);
    % plot_global_map(lats, lons, trend_EVI./mean_EVI, -0.02, 0.02, "EVI", c_map);
    
    A = trend_LAI<0;
    C = trend_EVI<0;
    D = A.*C;
    D(D<=0) = nan;
    plot_global_map(lats, lons, D, 0, 1, "LAI<0 & EVI<0", c_map);

    %plot_global_map(lats, lons, trend_LAI./mean_LAI - trend_EVI./mean_EVI, -0.02, 0.02, "Difference", c_map);
    
    % hcb = colorbar;
    %
    % x=get(hcb,'Position');
    % x(3)=0.02;
    % x(1)=0.935;
    % x(4)=0.8;
    % x(2)=0.08;
    % set(hcb,'Position',x)
    
    suptitle(scene_name)
    print(gcf, '-dtiff', '-r300', ['figures/difference_' scene_name '.tif'])
    close all
end
