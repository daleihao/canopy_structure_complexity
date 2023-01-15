load('all_data_2018_8.mat');
load('LAIs.mat');

lon = -179.95:0.1:179.95;
lat = 89.95:-0.1:-89.95;
[lons,lats]=meshgrid(lon,lat);


%% read data
FPARs = total_fpar_epic;
SIFs = total_sif_epic;
SIFPARs = total_sif_epic./(sw_total_epic*0.47);
fescs = NIRvs./FPARs;
cornbelt_region = double(geotiffread('cornbelt_area.tif'));
cornbelt_region = cornbelt_region<255;
amazon_region = double(geotiffread('amazon_area.tif'));
amazon_region = amazon_region>0;

load('landmask_0_1degree.mat');
landcovers = double(imread('0_1_MODIS_LC_2010.tif'));
sw_total(landmask == 0)=nan;
sw_total(landcovers<=0 | landcovers== 13 | landcovers>14) = nan;

amazon_region = amazon_region & landmask == 1 & ((landcovers>=1 & landcovers<= 12) | landcovers==14);

cornbelt_region = cornbelt_region & landmask == 1 & ((landcovers>=1 & landcovers<= 12) | landcovers==14);
% clip
EVI_data = EVIs;
DVI_data = DVIs;
EVI2_data = EVI2s;
NDVI_data = NDVIs;
SIF_data = SIFs;
SIFPAR_data = SIFPARs;
FPAR_data = FPARs;
LAI_data = LAIs;
NIRv_data = NIRvs;
fesc_data = fescs;

EVI_cb = EVI_data; EVI_cb(~cornbelt_region)=nan;
DVI_cb = DVI_data; DVI_cb(~cornbelt_region)=nan;
EVI2_cb = EVI2_data; EVI2_cb(~cornbelt_region)=nan;
NDVI_cb = NDVI_data; NDVI_cb(~cornbelt_region)=nan;
SIF_cb = SIF_data; SIF_cb(~cornbelt_region)=nan;
SIFPAR_cb = SIFPAR_data; SIFPAR_cb(~cornbelt_region)=nan;
FPAR_cb = FPAR_data; FPAR_cb(~cornbelt_region)=nan;
LAI_cb = LAI_data; LAI_cb(~cornbelt_region)=nan;
NIRv_cb = NIRv_data; NIRv_cb(~cornbelt_region)=nan;
fesc_cb = fesc_data; fesc_cb(~cornbelt_region)=nan;

fesc_cb = fesc_cb(420:530,735:990);
EVI_cb = EVI_cb(420:530,735:990);
DVI_cb = DVI_cb(420:530,735:990);
EVI2_cb = EVI2_cb(420:530,735:990);
NDVI_cb = NDVI_cb(420:530,735:990);
SIF_cb = SIF_cb(420:530,735:990);
SIFPAR_cb = SIFPAR_cb(420:530,735:990);
FPAR_cb = FPAR_cb(420:530,735:990);
LAI_cb = LAI_cb(420:530,735:990);
NIRv_cb = NIRv_cb(420:530,735:990);

EVI_an = EVI_data; EVI_an(~amazon_region)=nan;
DVI_an = DVI_data; DVI_an(~amazon_region)=nan;
EVI2_an = EVI2_data; EVI2_an(~amazon_region)=nan;
NDVI_an = NDVI_data; NDVI_an(~amazon_region)=nan;
SIF_an = SIF_data; SIF_an(~amazon_region)=nan;
SIFPAR_an = SIFPAR_data; SIFPAR_an(~amazon_region)=nan;
FPAR_an = FPAR_data; FPAR_an(~amazon_region)=nan;
LAI_an = LAI_data; LAI_an(~amazon_region)=nan;
NIRv_an = NIRv_data; NIRv_an(~amazon_region)=nan;
fesc_an = fesc_data; fesc_an(~amazon_region)=nan;

fesc_an = fesc_an(810:1100, 980:1380);
EVI_an = EVI_an(810:1100, 980:1380);
DVI_an = DVI_an(810:1100, 980:1380);
EVI2_an = EVI2_an(810:1100, 980:1380);
NDVI_an = NDVI_an(810:1100, 980:1380);
SIF_an = SIF_an(810:1100, 980:1380);
SIFPAR_an = SIFPAR_an(810:1100, 980:1380);
FPAR_an = FPAR_an(810:1100, 980:1380);
LAI_an = LAI_an(810:1100, 980:1380);
NIRv_an = NIRv_an(810:1100, 980:1380);

lats_an = lats(810:1100, 980:1380);
lons_an = lons(810:1100, 980:1380);

lats_cb = lats(420:530,735:990);
lons_cb = lons(420:530,735:990);

% plot
figure; 
set(gcf,'unit','normalized','position',[0.2,0.2,0.58,0.54]);
set(gca, 'Position', [0 0 1 1])

%% cornbelt
subplot('position',[0.08 0.61 0.3 0.35])
plot_global_map(lats_cb, lons_cb, SIF_cb,0,3,1,1);
title('SIF','fontsize',12, 'fontweight', 'bold')

ylabel('Corn Belt','fontweight','bold','fontsize',12);
subplot('position',[0.385 0.61 0.3 0.35])
plot_global_map(lats_cb, lons_cb, SIFPAR_cb,0,0.03,1,0);
title('SIF/PAR','fontsize',12, 'fontweight', 'bold')

subplot('position',[0.69 0.61 0.3 0.35])
plot_global_map(lats_cb, lons_cb, FPAR_cb,0,1,1,0);
title('FPAR','fontsize',12, 'fontweight', 'bold')



%% amazon
subplot('position',[0.08 0.14 0.3 0.46])
plot_global_map(lats_an, lons_an, SIF_an,0,3,1,1);
cb=colorbar('location','southoutside'); 
cb.Position = [0.095 0.06 0.27 0.04]; 

ylabel('Amazon Rainforest','fontweight','bold','fontsize',12);

subplot('position',[0.385 0.14 0.3 0.46])
plot_global_map(lats_an, lons_an, SIFPAR_an,0,0.04,1,0);
cb=colorbar('location','southoutside'); 
cb.Position = [0.40 0.06 0.27 0.04]; 

subplot('position',[0.69 0.14 0.3 0.46])
plot_global_map(lats_an, lons_an, FPAR_an,0,1,1,0);
cb=colorbar('location','southoutside'); 
cb.Position = [0.705 0.06 0.27 0.04]; 



%%
print(gcf, '-dtiff', '-r600', ['figure_S3a.tif'])
close all

