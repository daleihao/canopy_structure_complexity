library(tidyverse)
library(R.matlab)
library(cowplot)

setwd('D:/科研/pattern/Green_VI')

# import data
all_data <- readMat('Greens_data.mat')

Green_data <- as.data.frame(all_data['Greens'])  
colnames(Green_data) <- c('VIs','LCs')
G_NDVI_data <- as.data.frame(all_data['G.NDVIs'])  
colnames(G_NDVI_data) <- c('VIs','LCs')
GNDVI_data <- as.data.frame(all_data['GNDVIs'])  
colnames(GNDVI_data) <- c('VIs','LCs')
GCC_data <- as.data.frame(all_data['GCCs'])  
colnames(GCC_data) <- c('VIs','LCs')


Green_data$LCs <- as.factor(Green_data$LCs)
GNDVI_data$LCs <- as.factor(GNDVI_data$LCs)
GCC_data$LCs <- as.factor(GCC_data$LCs)
G_NDVI_data$LCs <- as.factor(G_NDVI_data$LCs)



plot_GNDVI <- ggplot(GNDVI_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('GNDVI') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Corn", "Amazon")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))+
  scale_y_continuous(limits = c(0, 1))


plot_GCC <- ggplot(GCC_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('GCC') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Corn", "Amazon")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1)) 

plot_Green <- ggplot(Green_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('Green') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Corn", "Amazon")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))+
  scale_y_continuous(limits = c(0, 0.08))
  

plot_G_NDVI <- ggplot(G_NDVI_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('Green*NDVI') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Corn", "Amazon")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))+
  scale_y_continuous(limits = c(0, 0.06))
#panel.border = element_rect (colour = "black", fill = F,size = 1))
#legend_1 <- get_legend(plot_LAI + theme(legend.position="right"))
  

plot_figure1 <- plot_grid(plot_Green + theme(legend.position="none"),
                          plot_GCC+ theme(legend.position="none"),
                          plot_GNDVI+ theme(legend.position="none"),
                          plot_G_NDVI + theme(legend.position="none"),
                          #labels = c("a", "b","c", "d"),
                          label_size = 25,
                          nrow = 1, ncol = 4, align = 'v')

ggsave("figure_green_b.tiff", plot = plot_figure1, width = 35, height = 7, units = "cm", dpi = 600, limitsize = FALSE, compression = "lzw")