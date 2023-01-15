%% get

clc;
clear all;
close all;

EVI_crop = imread('LUH2_data/EVI_crop_2018.tif');
EVI_forest = imread('LUH2_data/EVI_forest_2018.tif');
EVI_grass = imread('LUH2_data/EVI_grass_2018.tif');


LAI_crop = imread('LUH2_data/LAI_crop_2018.tif');
LAI_forest = imread('LUH2_data/LAI_forest_2018.tif');
LAI_grass = imread('LUH2_data/LAI_grass_2018.tif');

LAI_crop = double(LAI_crop)/10;
LAI_forest = double(LAI_forest)/10;
LAI_grass = double(LAI_grass)/10;

%filter
EVI_crop(EVI_crop<=0 | EVI_crop>=1) = nan;
EVI_forest(EVI_forest<=0  | EVI_forest>=1) = nan;
EVI_grass(EVI_grass<=0 | EVI_grass>=1) = nan;

LAI_crop(LAI_crop<=0 | LAI_crop>10) = nan;
LAI_forest(LAI_forest<=0 | LAI_forest>10) = nan;
LAI_grass(LAI_grass<=0 | LAI_grass>10) = nan;

% figure;
% colormap jet
% subplot(231)
% imagesc(EVI_crop,'AlphaData',~isnan(EVI_crop))
% caxis([0 1])
% title(['EVI-crop: ' num2str(nanmean(EVI_crop(:)))])
% subplot(232)
% imagesc(EVI_forest,'AlphaData',~isnan(EVI_forest))
% caxis([0 1])
% title(['EVI-forest: ' num2str(nanmean(EVI_forest(:)))])
%
% subplot(233)
% imagesc(EVI_grass,'AlphaData',~isnan(EVI_grass))
% caxis([0 1])
% title(['EVI-grass: ' num2str(nanmean(EVI_grass(:)))])
% colorbar
%
% subplot(234)
% imagesc(LAI_crop,'AlphaData',~isnan(LAI_crop))
% caxis([0 7])
%
% title(['LAI-crop: ' num2str(nanmean(LAI_crop(:)))])
%
% subplot(235)
% imagesc(LAI_forest,'AlphaData',~isnan(LAI_forest))
% caxis([0 7])
%
% title(['LAI-forest: ' num2str(nanmean(LAI_forest(:)))])
%
% subplot(236)
% imagesc(LAI_grass,'AlphaData',~isnan(LAI_grass))
% caxis([0 7])
%
% title(['LAI-grass: ' num2str(nanmean(LAI_grass(:)))])
% colorbar
%
%% climate zone
climate_zone = double(imread('LUH2_data/Beck_KG_V1_present_0p5.tif'));
x1 = 0.25:0.5:359.75;
y1 = 0.25:0.5:179.75;
[x1, y1] = meshgrid(x1,y1);

x2 = 0.125:0.25:359.975;
y2 = 0.125:0.25:179.975;
[x2, y2] = meshgrid(x2,y2);

climate_zone_025 = griddata(x1, y1, climate_zone, x2, y2, 'nearest');

climate_zones = nan(720, 1440);
climate_zones(climate_zone_025>=1 & climate_zone_025<=3) = 1;
climate_zones(climate_zone_025>=4 & climate_zone_025<=7) = 2;
climate_zones(climate_zone_025>=8 & climate_zone_025<=16) = 3;
climate_zones(climate_zone_025>=17 & climate_zone_025<=28) = 4;
climate_zones(climate_zone_025>=29 & climate_zone_025<=30) = 5;


% % get statistical
% LAI_crop_values = nan(720, 1440);
% LAI_forest_values = nan(720, 1440);
% LAI_grass_values = nan(720, 1440);
%
% EVI_crop_values = nan(720, 1440);
% EVI_forest_values = nan(720, 1440);
% EVI_grass_values = nan(720, 1440);
%
% climate_zones = int32(climate_zones);
% for climate_i = 1:5
%
%     LAI_crop_values(climate_zones==climate_i) = nanmean(LAI_crop(climate_zones==climate_i));
%     LAI_forest_values(climate_zones==climate_i) = nanmean(LAI_forest(climate_zones==climate_i));
%     LAI_grass_values(climate_zones==climate_i) = nanmean(LAI_grass(climate_zones==climate_i));
%
%     EVI_crop_values(climate_zones==climate_i) = nanmean(EVI_crop(climate_zones==climate_i));
%     EVI_forest_values(climate_zones==climate_i) = nanmean(EVI_forest(climate_zones==climate_i));
%     EVI_grass_values(climate_zones==climate_i) = nanmean(EVI_grass(climate_zones==climate_i));
% end
%
%
% LAI_crop_values = nan(720, 1440);
% LAI_forest_values = nan(720, 1440);
% LAI_grass_values = nan(720, 1440);
%
% EVI_crop_values = nan(720, 1440);
% EVI_forest_values = nan(720, 1440);
% EVI_grass_values = nan(720, 1440);
%
% climate_zones = int32(climate_zones);
%
% [cols, rows] = meshgrid(1:1440, 1:720);
% threshod = 10; % 10km
%
% tmp_LAI_crop = nan(720, 1440);
% tmp_LAI_crop(~isnan(LAI_crop)) = 1;
% tmp_LAI_forest = nan(720, 1440);
% tmp_LAI_forest(~isnan(LAI_forest)) = 1;
% tmp_LAI_grass = nan(720, 1440);
% tmp_LAI_grass(~isnan(LAI_grass)) = 1;
%
% tmp_EVI_crop = nan(720, 1440);
% tmp_EVI_crop(~isnan(EVI_crop)) = 1;
% tmp_EVI_forest = nan(720, 1440);
% tmp_EVI_forest(~isnan(EVI_forest)) = 1;
% tmp_EVI_grass = nan(720, 1440);
% tmp_EVI_grass(~isnan(EVI_grass)) = 1;
%
%
% tic
% for row_i = 1:600 %% 90:-60
%
%     tic
%     for col_j = 1:1440
%         if(climate_zones(row_i, col_j)>0 && climate_zones(row_i, col_j)<=5)
%
%             distances = sqrt((row_i - rows).^2 + (col_j - cols).^2)/4;
%             distances(distances>=threshod) = nan;
%             distances = 1./distances;
%             same_climate = nan(720, 1440);
%             same_climate(climate_zones == climate_zones(row_i, col_j)) = 1;
%             %% LAI
%             if (~isnan(LAI_crop(row_i, col_j)))
%                 LAI_crop_values(row_i, col_j) = LAI_crop(row_i, col_j);
%             else
%                 tmp = distances.*LAI_crop.*same_climate;
%                 if(nansum(tmp(:))>0)
%                     LAI_crop_values(row_i, col_j) = nansum(tmp(:))./nansum(distances(:).*tmp_LAI_crop(:).*same_climate(:));
%                 else
%                     LAI_crop_values(row_i, col_j) = nanmean(LAI_crop(:).*same_climate(:));
%                 end
%             end
%
%             if (~isnan(LAI_forest(row_i, col_j)))
%                 LAI_forest_values(row_i, col_j) = LAI_forest(row_i, col_j);
%             else
%                 tmp = distances.*LAI_forest.*same_climate;
%                 if(nansum(tmp(:))>0)
%                     LAI_forest_values(row_i, col_j) = nansum(tmp(:))./nansum(distances(:).*tmp_LAI_forest(:).*same_climate(:));
%                 else
%                     LAI_forest_values(row_i, col_j) = nanmean(LAI_forest(:).*same_climate(:));
%                 end
%             end
%             if (~isnan(LAI_grass(row_i, col_j)))
%                 LAI_grass_values(row_i, col_j) = LAI_grass(row_i, col_j);
%             else
%                 tmp = distances.*LAI_grass.*same_climate;
%                 if(nansum(tmp(:))>0)
%                     LAI_grass_values(row_i, col_j) = nansum(tmp(:))./nansum(distances(:).*tmp_LAI_grass(:).*same_climate(:));
%                 else
%                     LAI_grass_values(row_i, col_j) = nanmean(LAI_grass(:).*same_climate(:));
%                 end
%             end
%             %% EVI
%             if (~isnan(EVI_crop(row_i, col_j)))
%                 EVI_crop_values(row_i, col_j) = EVI_crop(row_i, col_j);
%             else
%                 tmp = distances.*EVI_crop.*same_climate;
%                 if(nansum(tmp(:))>0)
%                     EVI_crop_values(row_i, col_j) = nansum(tmp(:))./nansum(distances(:).*tmp_EVI_crop(:).*same_climate(:));
%                 else
%                     EVI_crop_values(row_i, col_j) = nanmean(EVI_crop(:).*same_climate(:));
%                 end
%             end
%
%             if (~isnan(EVI_forest(row_i, col_j)))
%                 EVI_forest_values(row_i, col_j) = EVI_forest(row_i, col_j);
%             else
%                 tmp = distances.*EVI_forest.*same_climate;
%                 if(nansum(tmp(:))>0)
%                     EVI_forest_values(row_i, col_j) = nansum(tmp(:))./nansum(distances(:).*tmp_EVI_forest(:).*same_climate(:));
%                 else
%                     EVI_forest_values(row_i, col_j) = nanmean(EVI_forest(:).*same_climate(:));
%                 end
%             end
%
%             if (~isnan(EVI_grass(row_i, col_j)))
%                 EVI_grass_values(row_i, col_j) = EVI_grass(row_i, col_j);
%             else
%                 tmp = distances.*EVI_grass.*same_climate;
%                 if(nansum(tmp(:))>0)
%                     EVI_grass_values(row_i, col_j) = nansum(tmp(:))./nansum(distances(:).*tmp_EVI_grass(:).*same_climate(:));
%                 else
%                     EVI_grass_values(row_i, col_j) = nanmean(EVI_grass(:).*same_climate(:));
%                 end
%             end
%         end
%     end
%     toc
% end
% save('alldata.mat', 'EVI_crop_values','EVI_forest_values','EVI_grass_values',...
%      'LAI_crop_values','LAI_forest_values','LAI_grass_values' ...
%     );
% toc


load('alldata.mat');
% figure;
% subplot(321)
% imagesc(EVI_crop_values)
% title('EVI crop interp')
% subplot(323)
% imagesc(EVI_forest_values)
% title('EVI forest interp')
% 
% subplot(325)
% imagesc(EVI_grass_values)
% title('EVI grass interp')
% 
% subplot(322)
% imagesc(LAI_crop_values)
% title('LAI CROP interp')
% subplot(324)
% imagesc(LAI_forest_values)
% title('LAI forest interp')
% 
% subplot(326)
% imagesc(LAI_grass_values)
% title('LAI grass interp')

% figure;
% subplot(1,2,1)
% bar(LAI_values')
% title('LAI')
% set(gca,'xticklabel',{'A','B','C','D','E'});
% legend('crop','forest','grass');
% subplot(1,2,2)
% bar(EVI_values')
% title('EVI')
% legend('crop','forest','grass');
% set(gca,'xticklabel',{'A','B','C','D','E'});


%% generate_data

files = dir('*.nc');
num = size(files, 1);




for i = 1:num
    filename = files(i).name;
    rcp_name = split(filename, '-');
    rcp_name = [char(rcp_name(3)) '-' char(rcp_name(4))];
    
    range = ncread(filename, 'range');
    pastr = ncread(filename, 'pastr');
    
    
    c3ann = ncread(filename, 'c3ann');
    c3nfx = ncread(filename, 'c3nfx');
    c3per = ncread(filename, 'c3per');
    c4ann = ncread(filename, 'c4ann');
    c4per = ncread(filename, 'c4per');
    
    primf = ncread(filename, 'primf');
    secdf = ncread(filename, 'secdf');
    
    primn = ncread(filename, 'primn');
    secdn = ncread(filename, 'secdn');
    
    
    fcrop = double(c3ann) + double(c3nfx) + double(c3per) + double(c4ann) + double(c4per);
    fforest = double(primf) + double(secdf);
    fgrass =  double(range) + double(pastr);
    
    fcrop(fcrop<0 | fcrop>1) = nan;
    fforest(fforest<0 | fforest>1) = nan;
    fgrass(fgrass<0 | fgrass>1) = nan;
    
    %     fother  = double(primn) + double(secdn);
    
    LAI = nan(720, 1440, 86);
    EVI = nan(720, 1440, 86);
    
    for t = 1:86
        LAI(:,:,t) = squeeze(fforest(:,:,t)').*LAI_forest_values+squeeze(fcrop(:,:,t)').*LAI_crop_values + squeeze(fgrass(:,:,t)').*LAI_grass_values;
        EVI(:,:,t) = squeeze(fforest(:,:,t)').*EVI_forest_values+squeeze(fcrop(:,:,t)').*EVI_crop_values + squeeze(fgrass(:,:,t)').*EVI_grass_values;
    end
    
    %% output
    trend_LAI = nan(720, 1440);
    trend_EVI = nan(720, 1440);
    H_LAI = nan(720, 1440);
    H_EVI = nan(720, 1440);
    
    sig_LAI = nan(720, 1440);
    sig_EVI = nan(720, 1440);
    
    mean_LAI = nan(720, 1440);
    mean_EVI = nan(720, 1440);
    
    years = [2015:1:2100]';
    tmps = ones(size(years));
    for k= 1:720
        for j = 1:1440
            if(LAI(k,j,1)>100 || LAI(k,j,1)<=0 || isnan(LAI(k,j,1)))
                continue;
            end
            
            
            %             [b,~,~,~,stats]  = regress(lai_tmp, [tmps years]);
            %             if(stats(4)<0.05)
            %                 trend_LAI(k,j) = b(2);
            %             end
            %             [b,~,~,~,stats]  = regress(evi_tmp, [ tmps years]);
            %             if(stats(4)<0.05)
            %                 trend_EVI(k,j) = b(2);
            %             end
            lai_tmp = squeeze(LAI(k,j,:));
            %lai_tmp = (lai_tmp-mean(lai_tmp))./mean(lai_tmp);            
            [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3] = ktaub([years lai_tmp], 0.05, 0);
            trend_LAI(k,j) = sen;
            sig_LAI(k,j) = sig;
            H_LAI(k,j) = h;
            mean_LAI(k,j) = nanmean(lai_tmp);
            
            evi_tmp = squeeze(EVI(k,j,:));
            %evi_tmp = (evi_tmp-mean(evi_tmp))./mean(evi_tmp);
            [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3] = ktaub([years evi_tmp], 0.05, 0);
            trend_EVI(k,j) = sen;
            sig_EVI(k,j) = sig;
            H_EVI(k,j) = h;
            mean_EVI(k,j) = nanmean(evi_tmp);
            
        end
    end
    
    %     Vforest =  fforest(:,:,end) - fforest(:,:,1);
    %     Vcrop =  fcrop(:,:,end) - fcrop(:,:,1);
    %
    %
    %     forest_2015 = fforest(:,:,1);
    %     crop_2015 = fcrop(:,:,1);
    %     forest_2100 = fforest(:,:,end);
    %     crop_2100 = fcrop(:,:,end);
    %
    %
    %     Vforest = flipud(Vforest');
    %     Vcrop = flipud(Vcrop');
    %     range = range(:,:,1)';
    %     range = (range>100);
    %
    %
    %     forest_2015 = flipud(forest_2015');
    %     crop_2015 = flipud(crop_2015');
    %
    %     forest_2100 = flipud(forest_2100');
    %     crop_2100 = flipud(crop_2100');
    
    
    %     trend_LAI = flipud(trend_LAI');
    %     trend_EVI = flipud(trend_EVI');
    
    %     figure;
    %     set(gcf, 'unit','normalized', 'position',[0.2, 0.2, 0.7, 0.3])
    %     set(gca, 'Position', [0 0 1 1])
    %     subplot(1,2,1)
    %     hold on
    %     imagesc(Vforest)
    %         colorbar
    %     caxis( [-0.3 0.3] )
    %
    %     h = imagesc(range)
    %     set(h, 'AlphaData', range*0.5)
    %      axis([0 1440 0 720])
    %
    %     title('Forest area difference between 2100 and 2015')
    %
    %     subplot(1,2,2)
    %     hold on
    %     imagesc(Vcrop)
    %     title('Crop area difference between 2100 and 2015')
    %     colorbar
    %     caxis( [-0.3 0.3] )
    %     h2 = imagesc(range*-1)
    %     set(h2, 'AlphaData', range*0.5)
    %
    %     axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %
    %     suptitle(rcp_name)
    %     print(gcf, '-dtiff', '-r600', [rcp_name '.tif'])
    %
    %     figure;
    %     set(gcf, 'unit','normalized', 'position',[0.2, 0.2, 0.7, 0.6])
    %      set(gca, 'Position', [0 0 1 1])
    %     subplot(2,2,1)
    %     hold on
    %         imagesc((Vcrop>0.1) & (Vforest<-0.1))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Crop >10% & Forest<-10%')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %
    %
    %      subplot(2,2,2)
    %     hold on
    %         imagesc((Vcrop>0.2) & (Vforest<-0.2))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Crop >20% & Forest<-20%')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %
    %
    %       subplot(2,2,3)
    %     hold on
    %         imagesc((Vcrop>0.3) & (Vforest<-0.3))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Crop >30% & Forest<-30%')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %
    %
    %      subplot(2,2,4)
    %     hold on
    %         imagesc((Vcrop>0.4) & (Vforest<-0.4))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Crop >40% & Forest<-40%')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %     suptitle(rcp_name)
    %      print(gcf, '-dtiff', '-r600', [rcp_name '_dif.tif'])
    
    
    %     figure;
    %     set(gcf, 'unit','normalized', 'position',[0.2, 0.2, 0.7, 0.6])
    %      set(gca, 'Position', [0 0 1 1])
    %     subplot(2,2,1)
    %     hold on
    %         imagesc(crop_2015>0.7 & (Vcrop>0.2) & (Vforest<-0.2))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Crop >70% in 2015')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %
    %
    %        subplot(2,2,2)
    %     hold on
    %         imagesc(crop_2100>0.7 & (Vcrop>0.2) & (Vforest<-0.2))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Crop >70% in 2100')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %
    %
    %        subplot(2,2,3)
    %     hold on
    %         imagesc(forest_2015>0.7 & (Vcrop>0.2) & (Vforest<-0.2))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Forest>70% in 2015')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %
    %      subplot(2,2,4)
    %     hold on
    %         imagesc(forest_2100>0.7 & (Vcrop>0.2) & (Vforest<-0.2))
    %          caxis( [-1 1] )
    %          h2 = imagesc(range*-1)
    %      set(h2, 'AlphaData', range*0.5)
    %     title('Forest >70% & in 2100')
    %    axis([0 1440 0 720])
    %     colormap(flipud(brewermap(9, 'PiYG')))
    %     suptitle(rcp_name)
    %      print(gcf, '-dtiff', '-r600', [rcp_name '_homo_change.tif'])
    
    
    save(['results/' rcp_name '.dat'],'trend_LAI', 'trend_EVI', ...
            'sig_LAI', 'sig_EVI',...
            'H_LAI', 'H_EVI',...
            'mean_LAI', 'mean_EVI');    
    %%
    figure;
    set(gcf, 'unit','normalized', 'position',[0.2, 0.2, 0.7, 0.3])
    set(gca, 'Position', [0 0 1 1])
    subplot(1,2,1)
    hold on
    imagesc(flipud(trend_LAI),'AlphaData', ~isnan(flipud(trend_LAI)))
    caxis( [-1e-2 1e-2] )
    colorbar
    
    title('LAI slope')
    axis([0 1440 0 720])
    colormap(flipud(brewermap(9, 'PiYG')))
    
    
    subplot(1,2,2)
    hold on
    h1 = imagesc(flipud(trend_EVI), 'AlphaData', ~isnan(flipud(trend_EVI)))
    caxis( [-1e-2 1e-2] )
    colorbar
    title('EVI slope')
    axis([0 1440 0 720])
    colormap(flipud(brewermap(9, 'PiYG')))
    
    suptitle(rcp_name)
    print(gcf, '-dtiff', '-r600', ['figures/new_threshold_' rcp_name '_veg_change.tif'])
end