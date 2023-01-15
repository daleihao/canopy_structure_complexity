sifs = ncread('TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc','sif');
nirs = ncread('TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc','nir');
szas = ncread('TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc','sza');

sif_monthly = nanmean(sifs, 3);
nirs_monthly = nanmean(nirs,3);
szas_monthly = nanmean(szas,3);

sif_monthly =flipud(sif_monthly');
nirs_monthly =flipud(nirs_monthly');
szas_monthly =flipud(szas_monthly');

Ref_nir = nirs_monthly./cos(szas_monthly*pi/180)/1368;

%% figure
load('VIs.mat');
figure;
colormap jet
subplot(2,2,1)
imagesc(sif_monthly)
title('SIF in August');
subplot(2,2,2)
imagesc(sif_monthly./(double(NDVIs).*nirs_monthly),[0 0.04])
title('SIF/NIRv\_radiance (MODIS NDVI, TOA NIR radiance)')
subplot(2,2,3)
imagesc(sif_monthly./(NIRvs.*PARs),[0 0.1])
title('SIF/NIRvP (MODIS NIRv, EPIC PAR)')

subplot(2,2,4)
fpars = imresize(total_fpar_epic, 0.5, 'nearest');
imagesc(sif_monthly./(fpars.*PARs),[0 0.05])
title('SIF/APAR')

%% plot phase angle
sifs = ncread('TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc','sif');
nirs = ncread('TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc','nir');
szas = ncread('TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc','sza');
phis = ncread('TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc','phase_angle');

load('ROI_regions.mat');

amazon_sifs = sifs.*repmat((flipud(amazon_region))', 1,1,31);
cornbelt_sifs = sifs.*repmat((flipud(cornbelt_region))', 1,1,31);

amazon_phis = phis.*repmat((flipud(amazon_region))', 1,1,31);
cornbelt_phis = phis.*repmat((flipud(cornbelt_region))', 1,1,31);


figure;
sifs2 = sifs;
sifs2(abs(phis)>10) = nan;
imagesc(flipud(nanmean(sifs2,3)'));
title('SIF when abs (phase angle) <= 10')
%% scatter
figure;
hold on
scatter(amazon_phis(:),amazon_sifs(:),2,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
scatter(cornbelt_phis(:),cornbelt_sifs(:),2,'MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);

legend('amazon','cornbelt');
% cornbelt_region = double(imread('cornbelt_area.tif'));
% cornbelt_region = cornbelt_region<255;
% amazon_region = double(imread('amazon_area.tif'));
% amazon_region = amazon_region>0;
% 
% amazon_region = imresize(amazon_region, 0.5, 'nearest');
% cornbelt_region = imresize(cornbelt_region, 0.5, 'nearest');

 NIRvs = imresize(NIRvs, 0.5, 'nearest');
 NDVIs = imresize(NDVIs, 0.5, 'nearest');
 PARs = imresize(par_total_epic, 0.5, 'nearest');
 
%% looad data
load('all_data_2018_8.mat');