FPARs = total_fpar_epic;
SIFs = total_sif_epic;
SIFPARs = total_sif_epic./(sw_total_epic*0.47);
cornbelt_region = double(geotiffread('cornbelt_area.tif'));
cornbelt_region = cornbelt_region<255;
amazon_region = double(geotiffread('amazon_area.tif'));
amazon_region = amazon_region>0;

figure;
colormap jet

for i = 1:2
    if i == 1
        roi_regions = cornbelt_region;
        title_text = 'Corn Belt';
    else
        roi_regions = amazon_region;
        title_text = 'Amazon Forest';
    end
    
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
        FPAR_data>0 & LAI_data>0 & NIRv_data>0 & ...
        EVI_data<1 & DVI_data<1 & EVI2_data<1 & NDVI_data<1 & SIF_data<10 & SIFPAR_data<1 & ...
        FPAR_data<1 & LAI_data<7 & NIRv_data<1;
    
    EVI_data = EVI_data(filters);
    DVI_data = DVI_data(filters);
    EVI2_data = EVI2_data(filters);
    NDVI_data = NDVI_data(filters);
    SIF_data = SIF_data(filters);
    SIFPAR_data = SIFPAR_data(filters);
    FPAR_data = FPAR_data(filters);
    LAI_data = LAI_data(filters);
    NIRv_data = NIRv_data(filters);
    
    subplot(2,6,1+6*(i-1))
    plot_scat( LAI_data,EVI_data, 'LAI', 'EVI');
    ylabel({title_text, 'EVI'});
    subplot(2,6,2+6*(i-1))
    plot_scat( LAI_data,NIRv_data, 'LAI',  'NIRv');
    subplot(2,6,3+6*(i-1))
    plot_scat( LAI_data,SIFPAR_data, 'LAI', 'SIF/PAR');
    
    
    subplot(2,6,4+6*(i-1))       
    plot_scat( FPAR_data,EVI_data, 'FPAR',  'EVI');
    subplot(2,6,5+6*(i-1))
    plot_scat( FPAR_data,NIRv_data, 'FPAR', 'NIRv');
    subplot(2,6,6+6*(i-1))
    plot_scat( FPAR_data,SIFPAR_data, 'FPAR', 'SIF/PAR');
    %suptitle(title_text)
    
end
print(gcf, '-dtiff', '-r600', ['figure_2_revise.tif'])

%     %% plot S2
%     figure;
%     colormap jet
%     subplot(231)
%     plot_scat(NIRv_data, SIF_data, 'NIRv', 'SIF');
%     subplot(232)
%     plot_scat(NIRv_data, EVI2_data, 'NIRv', 'EVI2');
%     subplot(233)
%     plot_scat(NIRv_data, NDVI_data, 'NIRv', 'NDVI');
%     subplot(234)
%     plot_scat(EVI2_data, FPAR_data, 'EVI2', 'FPAR');
%     subplot(235)
%     plot_scat(DVI_data, FPAR_data, 'DVI', 'FPAR');
%     subplot(236)
%     plot_scat(NDVI_data, FPAR_data,  'NDVI', 'FPAR');
%     suptitle(title_text)
%
%     print(gcf, '-dtiff', '-r600', ['figure_S2_' num2str(i) '.tif'])
%     close all
% end