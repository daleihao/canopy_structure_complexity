GNDVI = imread('GNDVIs_Globe.tif');
GREEN = imread('Greens_Globe.tif');
G_NDVI = imread('G_NDVIs2_Globe.tif');

figure;
subplot(131)
imagesc(GNDVI)
title('GNDVI')
colorbar
subplot(132)
imagesc(GREEN)
title('Green')
caxis([0 0.08])
colorbar
subplot(133)
imagesc(G_NDVI)
title('Green*NDVI')
caxis([0 0.08])
colorbar
colormap jet