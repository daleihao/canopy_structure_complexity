FPARs = total_fpar_epic;
SIFs = total_sif_epic;
SIFPARs = total_sif_epic./(sw_total_epic*0.47);
cornbelt_region = double(geotiffread('cornbelt_area.tif'));
cornbelt_region = cornbelt_region<255;
amazon_region = double(geotiffread('amazon_area.tif'));
amazon_region = amazon_region>0;

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
    
    all_data = [ NIRv_data EVI_data  DVI_data   EVI2_data    NDVI_data  SIF_data   SIFPAR_data    FPAR_data   LAI_data     ]; 
    R2_matrix = zeros(9,9);
    for k = 1:9
        for l = 1:9
            R2_tmp = corrcoef(all_data(:,k), all_data(:,l));
            R2_tmp = R2_tmp(1, 2);
            R2_tmp = R2_tmp^2;
            R2_matrix(k, l) = R2_tmp;
        end
    end
    save(['R2s_' num2str(i) '.mat'], 'R2_matrix');
end