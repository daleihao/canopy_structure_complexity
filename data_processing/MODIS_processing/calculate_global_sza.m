
res_v = 0.1;
res_h = 0.1;
lon = (-180+res_h/2):res_h: (180-res_h/2);
lat = (90-res_v/2):-res_v: (-90 + res_v/2);
[lons,lats]=meshgrid(lon,lat);

year_i = 2018;
month_i = 8;
SZAs = nan(1800,3600,31);
for day_i = 1:31
    datatime1= datetime(year_i,month_i,day_i,12,0,0);
    
    SZAs(:,:,day_i) = solarPosition(datatime1,lats, lons, lons/15);
end

SZA_noon_mean = nanmean(SZAs,3);

%% figure
load('landmask_0_1degree.mat');

SZA_noon_mean(landmask == 0)=nan;

figure;
set(gcf,'unit','normalized','position',[0.1,0.1,0.5,0.4]);
set(gca, 'Position', [0.03 0.1 0.9 0.85])

colors = flipud(brewermap(20, 'Spectral')); %% 
colormap(colors)

plot_global_map(lats, lons, SZA_noon_mean, 0, 60, '', 1, 1,'')
hcb = colorbar;
hcb.Title.String = "Degree";
set(gca,'fontsize',18)
x = hcb.Position;
x(1) = 0.91;
x(4) = 0.8;

hcb.Position = x;

% figure;
print(gcf, '-dtiff', '-r300', 'sza_noon.tif')
%%
cornbelt_region = double(imread('cornbelt_area.tif'));
cornbelt_region = cornbelt_region<255;
amazon_region = double(imread('amazon_area.tif'));
amazon_region = amazon_region>0;


sza_an = SZA_noon_mean;
sza_cb = SZA_noon_mean;
sza_an(~amazon_region) = nan;
sza_cb(~cornbelt_region) = nan;

[Area1, Area2, Area3] = CalculateArea(lats);

sum(Area1(amazon_region))
sum(Area1(cornbelt_region))

sum(Area2(amazon_region))
sum(Area2(cornbelt_region))

figure;
boxplot([sza_cb(:) sza_an(:)])
