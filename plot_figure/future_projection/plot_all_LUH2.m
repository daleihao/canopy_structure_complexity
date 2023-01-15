
c_map = flipud(brewermap(9, 'PiYG'));
%c_map = brewermap(9, 'PuOr');
scene_names = dir('../results/*.mat');
count = size(scene_names, 1);

res_v = 0.25;
res_h = 0.25;
lon = (-180+res_h/2):res_h: (180-res_h/2);
lat = (90-res_v/2):-res_v: (-90 + res_v/2);
[lons,lats]=meshgrid(lon,lat);

figure;
set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.9]);
set(gca, 'Position', [0 0 1 1])
t = tiledlayout(5,2,'TileSpacing','Compact','Padding','Compact');
sceneNames = {'IMAGE-SSP119',...
    'IMAGE-SSP126',...
    'MESSAGE-SSP245',...
    'AIM-SSP370',...
    'GCAM-SSP434',...
    'GCAM-SSP460',...
    'MAGPIE-SSP534',...
    'MAGPIE-SSP585'...
    };

for i = 1:count
    row_i = floor((i-1)/2)+1;
    col_i = mod(i,2);
    if col_i==0
        col_i = 2;
    end
    scene_name = sceneNames{i};
    load( ['../results/' scene_name]);
    filters = H_EVI<1 | sig_EVI>=0.05;
    trend_EVI(filters) = nan;
    filters = H_LAI<1 | sig_LAI>=0.05;
    trend_LAI(filters) = nan;
    
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
    
    
    subplot('Position',[0.07+(col_i-1)*0.46  0.21+0.20*(4-row_i) 0.44 0.17])
    if col_i == 1
        plot_global_map(lats, lons, D, 0, 1, scene_name(end-5:end), 0,1);
    else
        plot_global_map(lats, lons, D, 0, 1, scene_name(end-5:end), 0,0);    
    end
end


%% figure 9;

c_map = flipud(brewermap(9, 'PiYG'));
%c_map = brewermap(9, 'PuOr');
scene_names = dir('../results/*.mat');
count = size(scene_names, 1);
scenes = {'SSP119',...
    'SSP126',...
    'SSP245',...
    'SSP370',...
    'SSP434',...
    'SSP460',...
    'SSP534',...
    'SSP585'...
    };

areas = zeros(count, 3);

for i = 1:count
    
    
    load( ['../results/' sceneNames{i}]);
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
subplot('Position',[0.08 0.03 0.88 0.15])
bar(areas(:,1),'FaceColor',[27, 158, 119]/255,'EdgeColor',[0 0 0],'LineWidth',0.5)
set(gca, 'xticklabel', scenes, 'linewidth',1, 'fontsize', 10)
xlim([0.5 8.5])
ylim([0 2*1e7])
ylabel('Area (km^2)')

print(gcf, '-dtiff', '-r300', ['spaital_pattern.tif'])

close all

