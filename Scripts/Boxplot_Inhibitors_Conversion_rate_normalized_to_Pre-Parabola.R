#This script plots the conversion rates of each inhibitor after post-flight
#histamine treatment. Conversion rates are normalized to the pre-parabola 1
#flight phase.

#load libraries
extrafont::loadfonts("win")
library(ggplot2)
library(ggpubr)
library(hrbrthemes)
library(Cairo)
library(RColorBrewer)

#read csv file
PFC_Merged <- read.csv("Data_frames/PFC_Merged.csv")

#convert columns to numbers
PFC_Merged$col <- sprintf("%02d", as.numeric(PFC_Merged$col))
PFC_Merged$Well <- paste(PFC_Merged$row,PFC_Merged$col, sep = "")

#build phase column
PFC_Merged$phase <- paste(PFC_Merged$Condition, PFC_Merged$LED.trigger)

#subset for parabola and construct
subset <- subset(PFC_Merged, Construct == "CaMPARI2-F391W") 
  
#ordering of phases in their right timely manner
subset$phase <- factor(subset$phase, 
                             levels = c( "Pre-Parabola 1","Pre-Parabola 2",
                                         "Pull-up 1","Pull-up 2", "Zero-G 1",
                                         "Zero-G 2","Pull-out 1","Pull-out 2",
                                         "Post-Parabola 1","Post-Parabola 2"),
                             ordered = TRUE)

subset$Inhibitor <- factor(subset$Inhibitor,
                             levels = c("None", "DMSO", "Gd3+", "Ruthenium Red", "GSK2193874", "Thapsigargin", "Flunarizine", "BAPTA"))
  
HistamineSubset<- subset(subset, Condition == "Histamine")
  
#Change target subset for ConversionRate, IntegratedIntensity, RedMeanIntensity, Green_Red_Mean_Intensity
HistamineSubset$normalized <- HistamineSubset$ConversionRate - subset$ConversionRate[which(subset$phase== "Pre-Parabola 1")]
  
  
#plot conversion rate with boxplots, change y= to normalized/ConversionRate
boxplot <- ggplot(HistamineSubset, aes(x=Inhibitor, y=normalized, fill=Inhibitor)) + 
    geom_boxplot(outlier.size = 0.5, width = 0.55, position = position_dodge(width = 0.7)) +
    scale_x_discrete(expand = c(0,0.37)) +
    scale_fill_brewer(palette = "YlGnBu", direction = -1) +
    theme_light()+
    theme(
      text = element_text(size=13, family= "TT Arial" ),
      plot.title = element_text(size=13),
      strip.text = element_text(color = "black"),
      axis.title.y = element_text(size=10),
      axis.title.x = element_blank(),
      axis.text.y.left = element_text("ConversionRate"),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_text(size=10),
      legend.text = element_text(size=10),
      ) +
      ggtitle("ConversionRate")
  

#add t-test to plot that compares conversion rates of all treatments to the "None" treatment
symnum.args <- list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns")) 
figure <- boxplot + stat_compare_means(label = "p.signif", method = "t.test",
                               ref.group = "None",
                               symnum.args = symnum.args,
                               label.y = 0.3, hide.ns = TRUE)
  
#save as vector image in .eps format
ggsave(filename = "Figures/ConversionRate_Histamine_Inhibitors.eps", width = 12, height = 9, units = "cm", 
         plot = print(figure),
         device = cairo_ps)
  
  


