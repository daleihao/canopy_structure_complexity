FPARs = total_fpar_epic;
SIFs = total_sif_epic;
SIFPARs = total_sif_epic./(sw_total_epic*0.47);
cornbelt_region = double(geotiffread('cornbelt_area.tif'));
cornbelt_region = cornbelt_region<255;
amazon_region = double(geotiffread('amazon_area.tif'));
amazon_region = amazon_region>0;




roi_regions = cornbelt_region;


% clip
EVI_data = double(EVIs(roi_regions));
DVI_data = double(DVIs(roi_regions));
EVI2_data = double(EVI2s(roi_regions));
NDVI_data = double(NDVIs(roi_regions));
SIF_data = double(SIFs(roi_regions));
SIFPAR_data = double(SIFPARs(roi_regions));
FPAR_data = double(FPARs(roi_regions));
LAI_data = double(LAIs(roi_regions));
NIRv_data = double(NIRvs(roi_regions));

% filter data
filters = EVI_data>0 & DVI_data>0 & EVI2_data>0 & NDVI_data>0 & SIF_data>0 & SIFPAR_data>0 & ...
    FPAR_data>0 & LAI_data>0 & NIRv_data>0;

EVI_data_1 = EVI_data(filters);
DVI_data_1 = DVI_data(filters);
EVI2_data_1 = EVI2_data(filters);
NDVI_data_1 = NDVI_data(filters);
SIF_data_1 = SIF_data(filters);
SIFPAR_data_1 = SIFPAR_data(filters);
FPAR_data_1 = FPAR_data(filters);
LAI_data_1 = LAI_data(filters);
NIRv_data_1 = NIRv_data(filters);

roi_regions = amazon_region;

% clip
EVI_data = double(EVIs(roi_regions));
DVI_data = double(DVIs(roi_regions));
EVI2_data = double(EVI2s(roi_regions));
NDVI_data = double(NDVIs(roi_regions));
SIF_data = double(SIFs(roi_regions));
SIFPAR_data = double(SIFPARs(roi_regions));
FPAR_data = double(FPARs(roi_regions));
LAI_data = double(LAIs(roi_regions));
NIRv_data = double(NIRvs(roi_regions));

% filter data
filters = EVI_data>0 & DVI_data>0 & EVI2_data>0 & NDVI_data>0 & SIF_data>0 & SIFPAR_data>0 & ...
    FPAR_data>0 & LAI_data>0 & NIRv_data>0;

EVI_data_2 = EVI_data(filters);
DVI_data_2 = DVI_data(filters);
EVI2_data_2 = EVI2_data(filters);
NDVI_data_2 = NDVI_data(filters);
SIF_data_2 = SIF_data(filters);
SIFPAR_data_2 = SIFPAR_data(filters);
FPAR_data_2 = FPAR_data(filters);
LAI_data_2 = LAI_data(filters);
NIRv_data_2 = NIRv_data(filters);

%% figure;
figure; 
set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
set(gca, 'Position', [0.04 0.02 0.95 0.95])

subplot('position',[0.05 0.6 0.19 0.35])
plot_scat( LAI_data_1,EVI_data_1, 'LAI', 'EVI',7,0.8);
hold on
plot_scat_2( LAI_data_2,EVI_data_2, 'LAI', 'EVI',7,0.8);

subplot('position',[0.29 0.6 0.19 0.35])
plot_scat( LAI_data_1,NIRv_data_1, 'LAI',  'NIRv',7,0.45);
hold on
plot_scat_2( LAI_data_2,NIRv_data_2, 'LAI',  'NIRv',7,0.45);

subplot('position',[0.55 0.6 0.19 0.35])
plot_scat( LAI_data_1,SIFPAR_data_1, 'LAI', 'SIF/PAR',7,0.03);
hold on
plot_scat_2( LAI_data_2,SIFPAR_data_2, 'LAI', 'SIF/PAR',7,0.03);


subplot('position',[0.795 0.6 0.19 0.35])
plot_scat( LAI_data_1,NDVI_data_1, 'LAI', 'NDVI',7,1);
hold on
plot_scat_2( LAI_data_2,NDVI_data_2, 'LAI', 'NDVI',7,1);

%% FPAR
subplot('position',[0.05 0.13 0.19 0.35])
plot_scat( FPAR_data_1,EVI_data_1, 'FPAR', 'EVI',1,0.8);
hold on
plot_scat_2( FPAR_data_2,EVI_data_2, 'FPAR', 'EVI',1,0.8);

subplot('position',[0.29 0.13 0.19 0.35])
plot_scat( FPAR_data_1,NIRv_data_1, 'FPAR',  'NIRv',1,0.45);
hold on
plot_scat_2( FPAR_data_2,NIRv_data_2, 'FPAR',  'NIRv',1,0.45);

subplot('position',[0.55 0.13 0.19 0.35])
plot_scat( FPAR_data_1,SIFPAR_data_1, 'FPAR', 'SIF/PAR',1,0.03);
hold on
plot_scat_2( FPAR_data_2,SIFPAR_data_2, 'FPAR', 'SIF/PAR',1,0.03);


subplot('position',[0.795 0.13 0.19 0.35])
plot_scat( FPAR_data_1,NDVI_data_1, 'FPAR', 'NDVI',1,1);
hold on
plot_scat_2( FPAR_data_2,NDVI_data_2, 'FPAR', 'NDVI',1,1);


print(gcf, '-dtiff', '-r600', ['figure_2_revise.tif'])

