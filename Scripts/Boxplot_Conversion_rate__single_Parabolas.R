#This script plots the average conversion rates in all treatments and phases
#over all four individual parabolas.

#load libraries
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

PFC_Merged$phase <- paste(PFC_Merged$Condition, PFC_Merged$LED.trigger)

#subset for parabola and construct
subset <- subset(PFC_Merged, Construct == "CaMPARI2-F391W") 

#remove histamine controls
subset <- subset(subset, Condition != "Histamine")
  
#ordering of phases and conditions in their right timely manner
subset$phase <- factor(subset$phase, 
                             levels = c( "Pre-Parabola 1","Pre-Parabola 2","Pull-up 1","Pull-up 2",
                                         "Zero-G 1","Zero-G 2","Pull-out 1","Pull-out 2","Post-Parabola 1","Post-Parabola 2"),
                             ordered = TRUE)

subset$Condition <- factor(subset$Condition, 
                             levels = c( "Pre-Parabola","Pull-up","Zero-G","Pull-out","Post-Parabola"),
                             ordered = TRUE)

#convert parabola number to factor for plotting
subset$Parabola <- as.factor(subset$Parabola)
  
#plot panels with boxplots showing conversion rates for each parabola
boxplot <- ggplot(subset, aes(x=Parabola, y=ConversionRate, fill=Parabola)) + 
    geom_boxplot()+
    theme_light()+
    theme(
      text = element_text(size=13, family= "BF Tiny Hand" ),
      plot.title = element_text(size=13),
      strip.text = element_text(color = "black"),
      axis.title.y = element_text(size=10),
      axis.title.x = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_text(size=10),
      legend.text = element_text(size=10),
      )+
      ggtitle("Conversion rates per parabola")

#add t-test to plot that compares all parabolas to parabola 1 
figure <- boxplot + stat_compare_means(label = "p.signif", method = "t.test",
                               ref.group = "1",
                               label.y = 0.35, hide.ns = TRUE)

#print figure
print(figure)  

#save as vector image in .eps format
ggsave(filename = "Figures/ConversionRates_parabola.eps",
        plot = print(figure),
        device = cairo_ps)
 

  