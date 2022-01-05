#This script reads the accumulated PFC_Merged data frame and plots different
#analysis metrics including statistics

#loading libraries
extrafont::loadfonts("win")
library(ggplot2)
library(ggpubr)
library(hrbrthemes)
library(Cairo)

#read csv file
PFC_Merged <- read.csv("Data_frames/PFC_Merged.csv")

#convert columns to numbers
PFC_Merged$col <- sprintf("%02d", as.numeric(PFC_Merged$col))
PFC_Merged$Well <- paste(PFC_Merged$row,PFC_Merged$col, sep = "")

#create column describing the phase the measurement was taken
PFC_Merged$phase <- paste(PFC_Merged$Condition, PFC_Merged$LED.trigger)

#create new subset with construct of interest (CaMPARI2 or CaMPARI2-F391W)
subset <- subset(PFC_Merged, Construct == "CaMPARI2-F391W") 
  
#ordering of phases and conditions in their right timely manner
subset$phase <- factor(subset$phase, 
                             levels = c( "Pre-Parabola 1","Pre-Parabola 2",
                                         "Pull-up 1","Pull-up 2", "Zero-G 1",
                                         "Zero-G 2","Pull-out 1","Pull-out 2",
                                         "Post-Parabola 1","Post-Parabola 2"),
                             ordered = TRUE)
  
subset$Condition <- factor(subset$Condition, 
                             levels = c( "Pre-Parabola","Pull-up","Zero-G",
                                         "Pull-out","Post-Parabola", "Histamine"),
                             ordered = TRUE)


#Uncomment to select metric for plotting
metric <- "ConversionRate"
# metric <- "IntegratedIntensity"
# metric <- "RedMeanIntensity"
# metric <- "Green_Red_Mean_Intensity"
  
#plot panels with boxplots of selected metric
boxplot <- ggplot(subset, aes_string(x="phase", y=metric, fill="Condition")) + 
    geom_boxplot(outlier.size = 0.5,) +
    facet_wrap(~Inhibitor)+
    theme_light()+
    theme(
      text = element_text(size=13, family= "TT Arial" ),
      plot.title = element_text(size=13),
      strip.text = element_text(color = "black"),
      axis.title.y = element_text(size=10),
      axis.title.x = element_blank(),
      axis.text.y.left = element_text(metric),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_text(size=10),
      legend.text = element_text(size=10),
      ) +
      ggtitle(metric)

#add t-test to plot that compares all conditions to pre-parabola 1  
figure <- boxplot + stat_compare_means(label = "p.signif", method = "t.test",
                               ref.group = "Pre-Parabola 1",
                               label.y = 0.3, hide.ns = TRUE)
#print figure
print(figure)
  
#save as vector image in .eps format
ggsave(filename = "Figures/All_Inhibitors_All_parabolas_ConversionRate.eps",
      plot = print(figure),
      device = cairo_ps)
  
  


