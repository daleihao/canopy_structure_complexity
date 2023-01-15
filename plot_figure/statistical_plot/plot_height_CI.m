[cornbelt_region, R] = geotiffread('cornbelt_area.tif');

cornbelt_region = double(geotiffread('cornbelt_area.tif'));
cornbelt_region = cornbelt_region<255;
amazon_region = double(geotiffread('amazon_area.tif'));
amazon_region = amazon_region>0;
[heights, ~] = geotiffread('global_tree_height.tif');
heights = double(heights);

[CIs, ~] = geotiffread('201808_Globe_0.1_Degree.tif');
% clip
height_data = heights;
CI_data = double(squeeze(CIs(:,:,1)));
CI_data = CI_data/10000;
CI_data = 1-CI_data;
height_cb = height_data; height_cb(~cornbelt_region)=nan;
height_cb = height_cb(420:530,735:990);
height_an = height_data; height_an(~amazon_region)=nan;
height_an = height_an(810:1100, 980:1380);

CI_cb = CI_data; CI_cb(~cornbelt_region)=nan;
CI_cb = CI_cb(420:530,735:990);
CI_an = CI_data; CI_an(~amazon_region)=nan;
CI_an = CI_an(810:1100, 980:1380);

% plot
figure; 
set(gcf,'unit','normalized','position',[0.2,0.2,0.39,0.62]);
set(gca, 'Position', [0 0 1 1])

subplot('position',[0.02 0.65 0.46 0.3])
colormap(brewermap(20,'*RdBu'))
fig = imagesc(height_cb, [0 50]);
fig.AlphaData=~isnan(height_cb);
yticks([])
xticks([])
axis equal
title('Tree Height')

subplot('position',[0.52 0.65 0.46 0.3])
colormap(brewermap(20,'*RdBu'))
fig = imagesc(CI_cb, [0.1 0.5]);
fig.AlphaData=~isnan(CI_cb);
yticks([])
xticks([])
axis equal
title('1-CI')

% amazon
subplot('position',[0.02 0.17 0.46 0.45])
colormap(brewermap(20,'*RdBu'))
fig = imagesc(height_an, [0 50]);
fig.AlphaData=~isnan(height_an);
yticks([])
xticks([])
hold on
axis equal
cb=colorbar('location','southoutside'); 
cb.Position = [0.02 0.11 0.46 0.04]; 
%h = pointyColorbar(0,45,'location','westoutside');
%set(h,'location','northoutside');
h.maxw = 100;
subplot('position',[0.52 0.17 0.46 0.45])
colormap(flipud(brewermap(10,'*YlGN')))
fig = imagesc(CI_an, [0.1 0.5]);
fig.AlphaData=~isnan(CI_an);
yticks([])
xticks([])
axis equal
cb=colorbar('location','southoutside'); 
cb.Position = [0.52 0.11 0.46 0.04]; 
%cbarrow


print(gcf, '-dtiff', '-r600', ['figure_height_CI.tif'])
close all



