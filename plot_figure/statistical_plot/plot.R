library(tidyverse)
library(R.matlab)
library(cowplot)

setwd('D:/科研/pattern/plot_code')

# import data
all_data <- readMat('figure1_data.mat')

EVI_data <- as.data.frame(all_data['aEVIdata'])  
colnames(EVI_data) <- c('VIs','LCs')
NIRv_data <- as.data.frame(all_data['aNIRvdata'])  
colnames(NIRv_data) <- c('VIs','LCs')
NDVI_data <- as.data.frame(all_data['aNDVIdata'])  
colnames(NDVI_data) <- c('VIs','LCs')
SIF_data <- as.data.frame(all_data['aSIFdata'])  
colnames(SIF_data) <- c('VIs','LCs')
SIF_PAR_data <- as.data.frame(all_data['aSIFPARdata'])  
colnames(SIF_PAR_data) <- c('VIs','LCs')
fesc_data <- as.data.frame(all_data['afescdata'])  
colnames(fesc_data) <- c('VIs','LCs')
fpar_data <- as.data.frame(all_data['afpardata'])  
colnames(fpar_data) <- c('VIs','LCs')
LAI_data <- as.data.frame(all_data['aLAIdata'])  
colnames(LAI_data) <- c('VIs','LCs')
DVI_data <- as.data.frame(all_data['aDVIdata'])  
colnames(DVI_data) <- c('VIs','LCs')
EVI2_data <- as.data.frame(all_data['aEVI2data'])  
colnames(EVI2_data) <- c('VIs','LCs')

EVI_data$LCs <- as.factor(EVI_data$LCs)
DVI_data$LCs <- as.factor(DVI_data$LCs)
EVI2_data$LCs <- as.factor(EVI2_data$LCs)
NIRv_data$LCs <- as.factor(NIRv_data$LCs)
NDVI_data$LCs <- as.factor(NDVI_data$LCs)
SIF_data$LCs <- as.factor(SIF_data$LCs)
SIF_PAR_data$LCs <- as.factor(SIF_PAR_data$LCs)
fesc_data$LCs <- as.factor(fesc_data$LCs)
fpar_data$LCs <- as.factor(fpar_data$LCs)
LAI_data$LCs <- as.factor(LAI_data$LCs)


plot_DVI <- ggplot(DVI_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('DVI') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Corn Belt", "Amazon Rainforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))


plot_EVI2 <- ggplot(EVI2_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('EVI2') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))

plot_EVI <- ggplot(EVI_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('EVI') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
  

plot_NIRv <- ggplot(NIRv_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('NIRv') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
#panel.border = element_rect (colour = "black", fill = F,size = 1))

plot_NDVI <- ggplot(NDVI_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('NDVI') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") +
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
plot_fesc <- ggplot(fesc_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('fesc') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
plot_SIF <- ggplot(SIF_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('SIF') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
plot_SIF_PAR <- ggplot(SIF_PAR_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('SIF/PAR') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
plot_fpar <- ggplot(fpar_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('Fpar') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
plot_LAI <- ggplot(LAI_data, mapping = aes(x = LCs, y = VIs, color = LCs)) + ylab('LAI') +  #ggtitle(title_text) + 
  geom_violin(aes(fill = LCs),trim=TRUE, size = 0.5, show.legend = FALSE, adjust = .8) + 
  geom_boxplot(width=0.1, outlier.shape = NA, color = 'black', show.legend = FALSE) + 
  stat_summary(fun.y=mean, geom="point", color = 'red', alpha = 1, size=2, show.legend = F) + 
  scale_x_discrete(limits=c("0", "1"), labels = c("Cornbelt", "Amazonforest")) +
  scale_fill_brewer(palette="Dark2") + 
  scale_color_brewer(palette="Dark2") + 
  theme_classic() + 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_text(face="bold", color="black",size=20, angle=0),
        axis.text.y = element_text(face="bold", color="black", size=20, angle=0),
        axis.title.y = element_text(face="bold", color="black",size=20),
        axis.line = element_line(size = 1))
  
#legend_1 <- get_legend(plot_LAI + theme(legend.position="right"))
  
plot_figure1 <- plot_grid(plot_EVI + theme(legend.position="none"),
                          plot_SIF+ theme(legend.position="none"),
                          plot_fpar + theme(legend.position="none"),
                          plot_fesc + theme(legend.position="none"), 
                         labels = c("a", "b","c", "d"),
                         label_size = 25,
                         nrow = 2, ncol = 2, align = 'v')

plot_figure1 <- plot_grid(plot_EVI + theme(legend.position="none"),
                          plot_SIF+ theme(legend.position="none"),
                          plot_fpar + theme(legend.position="none"),
                          plot_fesc + theme(legend.position="none"), 
                          labels = c("a", "b","c", "d"),
                          label_size = 25,
                          nrow = 2, ncol = 2, align = 'v')

plot_figure1 <- plot_grid(plot_EVI + theme(legend.position="none"),
                          plot_NIRv+ theme(legend.position="none"),
                          plot_NDVI+ theme(legend.position="none"),
                          plot_LAI + theme(legend.position="none"),
                          plot_fesc + theme(legend.position="none"), 
                          #labels = c("a", "b","c", "d"),
                          label_size = 25,
                          nrow = 2, ncol = 2, align = 'v')
#plot_figure1 <- plot_grid( plot_figure1, legend_1, ncol = 2, rel_widths = c(1, .13))
plot_figureS1 <- plot_grid(plot_NIRv + theme(legend.position="none"),
                          plot_EVI2 + theme(legend.position="none"),
                          plot_DVI + theme(legend.position="none"),
                          plot_SIF_PAR+ theme(legend.position="none"),
                          plot_LAI + theme(legend.position="none"), 
                          plot_NDVI + theme(legend.position="none"),
                          labels = c("a", "b","c","d","e","f"),
                          label_size = 25,
                          nrow = 2, ncol = 3, align = 'v')
ggsave("figure_S1.tiff", plot = plot_figureS1, width = 40, height = 20, units = "cm", dpi = 600, limitsize = FALSE, compression = "lzw")
ggsave("figure_1.tiff", plot = plot_figure1, width = 40, height = 20, units = "cm", dpi = 600, limitsize = FALSE, compression = "lzw")