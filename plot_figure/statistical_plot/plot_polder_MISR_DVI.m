
clc;
clear all;
close all;

%% import data
% POLDER
EVICrop_P = importdata('POLDER-MISR/POLDER/Combine_DVI_CROP_Observation.txt');
EVIEBF_P = importdata('POLDER-MISR/POLDER/Combine_DVI_EBF_Observation.txt');
EVISIM_P = importdata('POLDER-MISR/POLDER/Combine_DVI_Simu.txt');

EVICrop_P = EVICrop_P.data;
EVIEBF_P = EVIEBF_P.data;
EVISIM_P = EVISIM_P.data;
EVISIMCROP_P = EVISIM_P(:,[1 3]);
EVISIMEBF_P = EVISIM_P(:,[1 2]);


%MISR
EVICrop_M = importdata('POLDER-MISR/MISR/Combine_DVI_CROP_Observation.txt');
EVIEBF_M = importdata('POLDER-MISR/MISR/Combine_DVI_EBF_Observation.txt');
EVISIM_M = importdata('POLDER-MISR/MISR/Combine_DVI_Simu.txt');

EVICrop_M = EVICrop_M.data;
EVIEBF_M = EVIEBF_M.data;
EVISIM_M = EVISIM_M.data;
EVISIMCROP_M = EVISIM_M(:,[1 3]);
EVISIMEBF_M = EVISIM_M(:,[1 2]);

figure;
set(gcf,'unit','normalized','position',[0.2,0.2,0.7,0.4]);
set(gca, 'Position', [0 0 1 1])

subplot('position',[0.08 0.25 0.42 0.65])
hold on
plot(EVICrop_P(:,1), EVICrop_P(:,2), '.b', 'Markersize', 10)
plot(EVIEBF_P(:,1), EVIEBF_P(:,2), '.r', 'Markersize', 10)
plot(EVISIMCROP_P(:,1), EVISIMCROP_P(:,2), '-b', 'Linewidth', 1)
plot(EVISIMEBF_P(:,1), EVISIMEBF_P(:,2), '-r', 'Linewidth', 1)
plot([0 0], [0 1], '--k', 'Linewidth', 1)

box on
axis([-100 40 0 0.6])
title('POLDER')
ylabel('DVI')
xlabel('Phase Angle  (Degree)')
set(gca, 'Linewidth', 1.5, ...
    'fontsize', 15, ...
    'xtick', [-90:30:30],...
    'ytick', [0:0.1:1])

legend({'Corn Belt', 'Amazon Forest'}, 'Location', 'Southwest')
% MISR
subplot('position',[0.55 0.25 0.42 0.65])
hold on
plot(EVICrop_M(:,1), EVICrop_M(:,2), '.b', 'Markersize', 10)
plot(EVIEBF_M(:,1), EVIEBF_M(:,2), '.r', 'Markersize', 10)
plot(EVISIMCROP_M(:,1), EVISIMCROP_M(:,2), '-b', 'Linewidth', 1)
plot(EVISIMEBF_M(:,1), EVISIMEBF_M(:,2), '-r', 'Linewidth', 1)
plot([0 0], [0 1], '--k', 'Linewidth', 1)


axis([-100 40 0 0.6])
box on
title('MISR')
xlabel('Phase Angle (Degree)')
set(gca, 'Linewidth', 1.5, ...
    'fontsize', 15, ...
    'xtick', [-90:30:30],...
    'ytick', [0:0.1:1])

%% save plots
print(gcf, '-dtiff', '-r600', ['figure_MISR_POLDER_DVI' '.tif'])
close all