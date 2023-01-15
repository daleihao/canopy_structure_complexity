
clc;
clear all;
close all;

%% import data
% POLDER
LAI_mean = importdata('trend_data/mean_LAI.csv', ',');
%LAI_std = importdata('trend_data/LAI_std.csv', ',');
EVI_mean = importdata('trend_data/mean_EVI.csv', ',');
%EVI_std = importdata('trend_data/EVI_std.csv', ',');

% LAI_mean = LAI_mean.data;
% LAI_std = LAI_std.data;
% EVI_mean = EVI_mean.data;
% EVI_std = EVI_std.data;

LAI_mean(:,2) = LAI_mean(:,2);
%LAI_std(:,2) = LAI_std(:,2)/10;
EVI_mean(:,2) = EVI_mean(:,2);
%EVI_std(:,2) = EVI_std(:,2)/1e4;

figure;
set(gcf,'unit','normalized','position',[0.2,0.2,0.7,0.4]);
set(gca, 'Position', [0 0 1 1])

subplot('position',[0.08 0.25 0.38 0.65])
hold on
plot(LAI_mean(:,1), LAI_mean(:,2), '.-r', 'Markersize', 15,  'Linewidth', 1)
%plot(EVIEBF_P(:,1), EVIEBF_P(:,2), '.b', 'Markersize', 10)
%plot([0 0], [0 1], '--k', 'Linewidth', 1)
lm = fitlm(LAI_mean(:,1), LAI_mean(:,2));
LAI_predict = lm.predict(LAI_mean(:,1));
plot(LAI_mean(:,1), LAI_predict, '--b',  'Linewidth', 1)
summary_LAI =  anova(lm,'summary');
p_value = summary_LAI.pValue;
p_value = p_value(2);
coefs = lm.Coefficients;
slope_value =coefs{2, 1};

text(2003, 0.1, ['Slope=' num2str(slope_value, '%.4f')], 'color', 'b', 'fontsize', 14)
text(2003, 0, ['P-value=' num2str(p_value, '%.4f')], 'color','b', 'fontsize', 14)

%text()
box on
axis([2003-0.5 2020.5 -0.2 0.2])
ylabel('LAI')
xlabel('Year')
set(gca, 'Linewidth', 1.5, ...
    'fontsize', 15, ...
    'xtick', [2005:5:2020],...
    'ytick', [1:0.5:7])

%legend({'Corn Belt', 'Amazon Forest'}, 'Location', 'Southwest')
% MISR
subplot('position',[0.56 0.25 0.38 0.65])
hold on
plot(EVI_mean(:,1), EVI_mean(:,2), '.-r', 'Markersize', 15, 'Linewidth', 1)
lm = fitlm(EVI_mean(:,1), EVI_mean(:,2));
EVI_predict = lm.predict(EVI_mean(:,1));
plot(EVI_mean(:,1), EVI_predict, '--b',  'Linewidth', 1)
summary_EVI =  anova(lm,'summary');
p_value = summary_EVI.pValue;
p_value = p_value(2);
coefs = lm.Coefficients;
slope_value =coefs{2, 1};

text(2003, 0.1, ['Slope=' num2str(slope_value, '%.4f')], 'color', 'b', 'fontsize', 14)
text(2003, 0, ['P-value=' num2str(p_value, '%.4f')], 'color','b', 'fontsize', 14)
%plot([0 0], [0 1], '--k', 'Linewidth', 1)


axis([2003-0.5 2020.5 -0.2 0.2])
box on
xlabel('Year')
ylabel('EVI')
set(gca, 'Linewidth', 1.5, ...
    'fontsize', 15, ...
    'xtick', [2005:5:2020],...
    'ytick', [0:0.05:1])

%% save plots
print(gcf, '-dtiff', '-r600', ['figure_trend' '.tif'])
close all