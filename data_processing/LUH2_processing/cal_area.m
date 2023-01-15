
c_map = flipud(brewermap(9, 'PiYG'));
%c_map = brewermap(9, 'PuOr');
scene_names = dir('../results/*.mat');
count = size(scene_names, 1);

areas = zeros(count, 3);
scenenames = cell(count, 1);
for i = 1:count
    
    scene_name = scene_names(i).name;
    scene_name = scene_name(1:end-4);
    scenenames{i} = scene_name(end-5:end);
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
    
    [Area1, Area2, Area3] = CalculateArea(lats);
   % subplot('Position', [0.04 0.53 0.42 0.4]);
    
    % plot_global_map(lats, lons, trend_LAI./mean_LAI, -0.02, 0.02, "LAI", c_map);
    A1 = trend_LAI>0;
    B1 = isnan(trend_EVI);
    C1 = trend_EVI<0;
    D1 = A1.*(B1 | C1);
    
    A2 = trend_LAI<0;
    B2 = isnan(trend_EVI);
    C2 = trend_EVI>0;
    D2 = A2.*(B2 | C2);
    
    D = double(D1 | D2);
    D(D<=0) = nan;
    
    areas(i,1) = nansum(Area1(:).*D(:));
    areas(i,2) = nansum(Area2(:).*D(:));
    areas(i,3) = nansum(Area3(:).*D(:));
end


%% plot
figure;
bar(areas(:,1))
set(gca, 'xticklabel', scenenames, 'linewidth',1, 'fontsize', 12)
xlim([0 9])
ylabel('Area (km^2)')

