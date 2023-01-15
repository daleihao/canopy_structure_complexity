library(R.matlab)
library(cowplot)
library(corrplot)
library(RColorBrewer)
setwd('D:/科研/pattern/plot_code')


# import data
all_data <- readMat('R2s_1.mat')

col3 <- colorRampPalette(c("red", "white", "blue"))


tiff("figure_3_revise.tiff", width = 38, height = 19, units = 'cm', res = 300, compression = "lzw")
par(mfrow=c(1,2))

data <- as.matrix(all_data[[1]])

rownames(data) <- c('NIRv','EVI','DVI','EVI2','NDVI','SIF','SIF/PAR','FPAR','LAI')
colnames(data) <- c('NIRv','EVI','DVI','EVI2','NDVI','SIF','SIF/PAR','FPAR','LAI')
data <- data[c(1,2,5,6,7,8,9), c(1,2,5,6,7,8,9)] 
corrplot(data, type = "upper", col = rep(rev(brewer.pal(n=10, name="RdYlBu")), 2),   addCoef.col = "black", 
                    tl.col = "black", tl.srt = 45,  number.digits = 2, cl.lim = c(0, 1), is.corr = FALSE, mar=c(0,0,0.5,0),
         tl.cex = 1.1, cl.cex = 1.2)
 title (main = "a. Corb Belt", outer = F, cex.main = 1.5 )
 


all_data <- readMat('R2s_2.mat')
data <- all_data[[1]]

rownames(data) <- c('NIRv','EVI','DVI','EVI2','NDVI','SIF','SIF/PAR','FPAR','LAI')
colnames(data) <- c('NIRv','EVI','DVI','EVI2','NDVI','SIF','SIF/PAR','FPAR','LAI')
data <- data[c(1,2,5,6,7,8,9), c(1,2,5,6,7,8,9)]
corrplot(data, type = "upper", col = rep(rev(brewer.pal(n=10, name="RdYlBu")), 2),   addCoef.col = "black", 
         tl.col = "black", tl.srt = 45,  number.digits = 2, cl.lim = c(0, 1), is.corr = FALSE, mar=c(0,0,2,0), tl.cex = 1.1, cl.cex = 1.2)
title (main = "b. Amazon Rainforest", outer = F, cex.main = 1.5)



#plot_figure3 <- plot_grid(plot_cb + theme(legend.position="none"),
#                          plot_an+ theme(legend.position="none"),
 #                          labels = c("a", "b"),
  #                         label_size = 25,
   #                        nrow = 1, ncol = 2, align = 'v')
#plot_figure3 <- plot_grid( plot_figure3, legend_1, ncol = 2, rel_widths = c(1, .13))


#this is my only addition


dev.off()