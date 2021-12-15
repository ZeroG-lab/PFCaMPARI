extrafont::loadfonts("win")
library(ggplot2)
library(ggpubr)
library(hrbrthemes)
library(Cairo)

#read csv file
PFC_Merged <- read.csv("PFC_Merged.csv")

#convert columns to numbers
PFC_Merged$col <- sprintf("%02d", as.numeric(PFC_Merged$col))
PFC_Merged$Well <- paste(PFC_Merged$row,PFC_Merged$col, sep = "")

PFC_Merged$phase <- paste(PFC_Merged$Condition, PFC_Merged$LED.trigger)

#subset for parabola and construct
#p <- c(1,2,3,4)

#for (i in p) {
  subset <- subset(PFC_Merged, Construct == "CaMPARI2-F391W") 
  
  #ordering of phases in their reight timely manner
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
  
  #plot panels with boxplots/ Change Y and Title  to ConversionRate, IntegratedIntensity, RedMeanIntensity, Green_Red_Mean_Intensity
  boxplot <- ggplot(subset, aes(x=phase, y=ConversionRate, fill=Condition)) + 
    geom_boxplot(outlier.size = 0.5,) +
    facet_wrap(~Inhibitor)+
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
    
    ggtitle(paste0("ConversionRate"))
  
  figure <- boxplot + stat_compare_means(label = "p.signif", method = "t.test",
                               ref.group = "Pre-Parabola 1",
                               label.y = 0.3, hide.ns = TRUE)
  print(figure)
  
  #save as vector graphic in .eps format
  ggsave(filename = paste0("All_Inhibitors_All_parabolas_RedMeanIntensity",".eps"),
         plot = print(figure),
         device = cairo_ps)
  
  
#}

