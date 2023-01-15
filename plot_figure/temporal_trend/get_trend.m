clc;
clear all;
close all;


LAIs = importdata('all_points_LAI_all.csv');
EVIs = importdata('all_points_EVI_all.csv');

LAIs = LAIs.data;
EVIs = EVIs.data;
IDs = LAIs(:,3);
Years = LAIs(:,4);
LAIs = LAIs(:,2);
EVIs = EVIs(:,2);

num = size(unique(IDs),1);
stat_EVI = nan(num,2);
stat_LAI = nan(num,2);

for id = min(IDs):max(IDs)

    filters = IDs == id;
    year_i = Years(filters);
    LAI_i = LAIs(filters);
    EVI_i = EVIs(filters);
    
    [taub tau h sig1 Z S sigma sen1 n senplot CIlower CIupper D Dall C3 nsigma] = ktaub([year_i LAI_i], 0.05, 0);
    [taub tau h sig2 Z S sigma sen2 n senplot CIlower CIupper D Dall C3 nsigma] = ktaub([year_i EVI_i], 0.05, 0);

    stat_LAI(id+1,1) = sen1;
    stat_LAI(id+1,2) = sig1;

    stat_EVI(id+1,1) = sen2;
    stat_EVI(id+1,2) = sig2;
              
%     filter = sen1<0 & sen2>0 & sig1<0.05 & sig2<0.05;
%     if(filter==1)
%         figure;
%         hold on
%     plot(year_i,LAI_i,'r')
%      plot(year_i,EVI_i,'g')
%      hold off
%     end
end

%% figure
figure;
%% plot
a = [stat_LAI(stat_LAI(:,2)<0.05,1)];
b = [stat_EVI(stat_EVI(:,2)<0.05,1)];

filters = stat_LAI(:,2)<0.05 & stat_EVI(:,2)<0.05 & stat_LAI(:,1)<0 & stat_EVI(:,2)>0;
data = nan(1730,2);
data(:,2) = b;
data(1:307,1) = a;

figure;
boxplot(data)
ylim([-0.08 0.08])
set(gca,'xticklabel',{'Normalized LAI','Noramlized EVI'},'linewidth',1,'fontsize',12)
ylabel('Slope')



%% figure
figure;
hist([stat_LAI(:,1),stat_EVI(:,1)],[100])