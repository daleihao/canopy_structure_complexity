
clc;
clear all;
close all;

%% import data
% POLDER
LAI_mean = importdata('trend_data/LAI_site.csv', ',');
%LAI_std = importdata('trend_data/LAI_std.csv', ',');
EVI_mean = importdata('trend_data/EVI_site.csv', ',');
%EVI_std = importdata('trend_data/EVI_std.csv', ',');

% LAI_mean = LAI_mean.data;
% LAI_std = LAI_std.data;
% EVI_mean = EVI_mean.data;
% EVI_std = EVI_std.data;

LAI_mean(:,[2 3]) = LAI_mean(:,[2 3])/10;
%LAI_std(:,2) = LAI_std(:,2)/10;
EVI_mean(:,[2 3]) = EVI_mean(:,[2 3])/1e4;
%EVI_std(:,2) = EVI_std(:,2)/1e4;

[taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3 nsigma] = ktaub([LAI_mean(:,1) LAI_mean(:,2)], 0.05, 0);
[taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3 nsigma] = ktaub([LAI_mean(:,1) LAI_mean(:,3)], 0.05, 0);

[taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3 nsigma] = ktaub([EVI_mean(:,1) EVI_mean(:,2)], 0.05, 0);
[taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3 nsigma] = ktaub([EVI_mean(:,1) EVI_mean(:,3)], 0.05, 0);

figure;
set(gcf,'unit','normalized','position',[0.2,0.2,0.8,0.5]);
set(gca, 'Position', [0 0 1 1])

subplot('position',[0.08 0.25 0.38 0.65])
hold on
plot(LAI_mean(:,1), LAI_mean(:,2), '.-r', 'Markersize', 15,  'Linewidth', 1,'color',[27 158 119]/255)
%plot(EVIEBF_P(:,1), EVIEBF_P(:,2), '.b', 'Markersize', 10)
%plot([0 0], [0 1], '--k', 'Linewidth', 1)
lm = fitlm(LAI_mean(:,1), LAI_mean(:,2));
LAI_predict = lm.predict(LAI_mean(:,1));
plot(LAI_mean(:,1), LAI_predict, '--r',  'Linewidth', 2,'color',[27 158 119]/255)
summary_LAI =  anova(lm,'summary');
p_value = summary_LAI.pValue;
p_value = p_value(2);
coefs = lm.Coefficients;
slope_value =coefs{2, 1};

text(2012, 3.8, ['Slope=' num2str(slope_value, '%.2f') ', P=' num2str(p_value, '%.2f')], 'color', [27 158 119]/255, 'fontsize', 12,'fontweight','bold')
%text(2013, 3.5, [], 'color','r', 'fontsize', 12)


plot(LAI_mean(:,1), LAI_mean(:,3), '.-b', 'Markersize', 15,  'Linewidth', 1,'color',[217 95 2]/255)
%plot(EVIEBF_P(:,1), EVIEBF_P(:,2), '.b', 'Markersize', 10)
%plot([0 0], [0 1], '--k', 'Linewidth', 1)
lm = fitlm(LAI_mean(:,1), LAI_mean(:,3));
LAI_predict = lm.predict(LAI_mean(:,1));
plot(LAI_mean(:,1), LAI_predict, '--b',  'Linewidth', 2,'color',[217 95 2]/255)
summary_LAI =  anova(lm,'summary');
p_value = summary_LAI.pValue;
p_value = p_value(2);
coefs = lm.Coefficients;
slope_value =coefs{2, 1};

text(2012, 3.4, ['Slope=' num2str(slope_value, '%.2f') ', P=' num2str(p_value, '%.2f')], 'color', [217 95 2]/255, 'fontsize', 12,'fontweight','bold')
%text(2013, 2.9, [], 'color','b', 'fontsize', 12)

%text()
box on
axis([2003-0.5 2020.5 0.5 4])
ylabel('LAI')
xlabel('Year')
set(gca, 'Linewidth', 1.5, ...
    'fontsize', 15, ...
    'xtick', [2005:5:2020],...
    'ytick', [0:1:7])

%legend({'Corn Belt', 'Amazon Forest'}, 'Location', 'Southwest')
% MISR
subplot('position',[0.56 0.25 0.38 0.65])
hold on
plot(EVI_mean(:,1), EVI_mean(:,2), '.-r', 'Markersize', 15, 'Linewidth', 1,'color',[27 158 119]/255)
plot(EVI_mean(:,1), EVI_mean(:,3), '.-b', 'Markersize', 15, 'Linewidth', 1,'color',[217 95 2]/255)
lm = fitlm(EVI_mean(:,1), EVI_mean(:,2));
EVI_predict = lm.predict(EVI_mean(:,1));
plot(EVI_mean(:,1), EVI_predict, '--r',  'Linewidth', 2,'color',[27 158 119]/255)
summary_EVI =  anova(lm,'summary');
p_value = summary_EVI.pValue;
p_value = p_value(2);
coefs = lm.Coefficients;
slope_value =coefs{2, 1};

text(2012, 0.35, ['Slope=' num2str(slope_value, '%.3f') ', P=' num2str(p_value, '%.2f')], 'fontsize', 12,'color',[27 158 119]/255,'fontweight','bold')
%text(2008, 0.32, [], 'color','r', 'fontsize', 12)
%plot([0 0], [0 1], '--k', 'Linewidth', 1)


lm = fitlm(EVI_mean(:,1), EVI_mean(:,3));
EVI_predict = lm.predict(EVI_mean(:,1));
plot(EVI_mean(:,1), EVI_predict, '--b',  'Linewidth', 2,'color',[217 95 2]/255)
summary_EVI =  anova(lm,'summary');
p_value = summary_EVI.pValue;
p_value = p_value(2);
coefs = lm.Coefficients;
slope_value =coefs{2, 1};

text(2012, 0.32, ['Slope=' num2str(slope_value, '%.3f'), ', P=' num2str(p_value, '%.2f')], 'color', [217 95 2]/255, 'fontsize', 12,'fontweight','bold')
%text(2013, 0.42, ['P-value=' num2str(p_value, '%.4f')], 'color','r', 'fontsize', 12)

axis([2003-0.5 2020.5 0.3 0.62])
box on
xlabel('Year')
ylabel('EVI')
set(gca, 'Linewidth', 1.5, ...
    'fontsize', 15, ...
    'xtick', [2005:5:2020],...
    'ytick', [0:0.1:1])
legend({'Site1', 'Site2'}, 'Location', 'Northwest', 'Orientation', 'Horizontal')
%% save plots
print(gcf, '-dtiff', '-r600', ['figure_trend_site' '.tif'])
close all