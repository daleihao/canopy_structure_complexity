
%% lat lon

lon = -179.95:0.1:179.95;
lat = 89.95:-0.1:-89.95;
[lons,lats]=meshgrid(lon,lat);

load('all_data_2018_8.mat');
load('LAIs.mat');
%% plot
%%
% max_clr = 5;
% figure;
% set(gcf,'unit','normalized','position',[0.1,0.1,0.38,0.3]);
% set(gca, 'Position', [0.05 0 0.95 1])
% plot_global_map(lats, lons, casaclm_Rh, 0, max_clr, 'CASACLM', colors_single);
% hcb = colorbar;
% hcb.Title.String = 'gC m^{-2} day^{-1}';
% print(gcf, '-dtiff', '-r600', 'casaclm.tif')
%
% figure;
% colormap(colors_single)
% set(gcf,'unit','normalized','position',[0.1,0.1,0.38,0.3]);
% set(gca, 'Position', [0.05 0 0.95 1])
% plot_global_map(lats, lons, warner_high_Rh, 0, max_clr, 'Warner et al. (2020)', colors_single);
% hcb = colorbar;
% hcb.Title.String = 'gC m^{-2} day^{-1}';
% print(gcf, '-dtiff', '-r600', 'warner.tif')

% Modify Colorbar to a manual setting
%set(h,'pos',[0.94 0.55 0.012 0.38],'tickdir','out') CASACLM - Warner et al. (2020)


%% plot vegetation
plot_global_map(lats, lons, EVIs, 'EVI',0.8);
% plot_global_map(lats, lons, NDVIs, 'NDVI', 1);
% %plot_global_map(lats, lons, EVI2s, 'EVI2', 0.8);
% %plot_global_map(lats, lons, DVIs, 'DVI',0.4);
% plot_global_map(lats, lons, NIRvs, 'NIRv', 0.4);
% plot_global_map(lats, lons, NIRs, 'NIRt', 0.6);
% %plot_global_map(lats, lons, Reds, 'Red', 0.5);
% %plot_global_map(lats, lons, NIRs_NIRvs, 'NIR-NIRv', 0.6);
% %% par,gpp,fpar
% %plot_global_map(lats, lons, par_total_epic, 'PAR-EPIC', 160);
% plot_global_map(lats, lons, total_fpar_epic, 'FPAR', 1);
% %plot_global_map(lats, lons, total_gpp_epic, 'GPP-FLUXCOM', 10);
% plot_global_map(lats, lons, total_sif_epic, 'SIF', 2);
% plot_global_map(lats, lons, NIRvs./total_fpar_epic, 'fesc', 0.6);
% %plot_global_map(lats, lons, total_gpp_epic./par_total_epic, 'gpp_divided_by_par', 0.09);
% %plot_global_map(lats, lons, total_gpp_epic./(par_total_epic.*total_fpar_epic), 'gpp_divided_by_apar', 0.1);
% %plot_global_map(lats, lons, par_total_epic.*total_fpar_epic, 'apar', 100);
% 
% 
% plot_global_map(lats, lons, LAIs, 'LAI', 7);
% plot_global_map(lats, lons, total_sif_epic./par_total_epic, 'SIF/PAR', 0.02);
