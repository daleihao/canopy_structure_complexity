
library(tidyverse)
library(reshape2)
library(ggplot2)

setwd('C:/Users/haod776/OneDrive - PNNL/Documents/work/co-authors/pattern/data')
# Change box plot colors by groups
EVIs <- read_csv('all_points_EVI_all_new.csv');
LAIs <- read_csv('all_points_LAI_all_new.csv');
#EVIs$year <- as.factor(EVIs$year)
#LAIs$year <- as.factor(LAIs$year)

Alldata <- EVIs %>%
  left_join(LAIs, by = c('id','year')) %>%
  select(id, year, EVI_n, Lai_n) %>%
  rename(EVI = EVI_n, LAI = Lai_n) %>%
  melt(id = c('id','year'))

Alldata_mean <- Alldata %>%
  group_by(year,variable) %>%
  summarise( value = mean(value))
meanEVIs <- Alldata_mean %>% 
  filter(variable == 'EVI')
meanLAIs <- Alldata_mean %>% 
  filter(variable == 'LAI')
  
plot_figure = ggplot(Alldata, aes(x=as.factor(year), y=value,fill = variable)) +
  ylab('Normalized LAI/EVI') +
  xlab('Year') +
  geom_boxplot(position=position_dodge(1),outlier.shape = NA) +
  scale_y_continuous(limits = c(-0.5, 0.5)) +
  theme_classic() +
  theme(plot.title = element_text(face="bold", color="black",size=11, angle=0),
        #axis.title.x=element_blank(),
        axis.text.x = element_text(color="black",size=12, angle=0),
        axis.text.y = element_text( color="black", size=12, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=10),
        axis.line = element_line(size = 0.5),
        legend.position = c(0.1, 0.9),
        legend.title=element_blank()) +
  scale_fill_brewer(palette="Dark2") +
  #stat_summary(fun = "median", geom="line", aes(group=variable))  
  scale_x_discrete( breaks = c('2002','2004','2006','2008','2010','2012','2014','2016','2018','2020'), labels= c('2002','2004','2006','2008','2010','2012','2014','2016','2018','2020')) +
 # xlim(c(2002,2021)) +
 geom_smooth( data = meanEVIs, mapping = aes(x=as.factor(year), y=value,group=1),color = "#1b9e77", method = "lm", se = FALSE,show.legend = FALSE) +
geom_smooth( data = meanLAIs, mapping = aes(x=as.factor(year), y=value,group=1), color = "#d95f02" ,method = "lm", se = FALSE,show.legend = FALSE)
  

ggsave("figure_4b.tiff", plot = plot_figure, width = 15, height = 7, units = "cm", dpi = 300, limitsize = FALSE, compression = "lzw")