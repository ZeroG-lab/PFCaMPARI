extrafont::loadfonts("win")
library(ggplot2)
library(ggpubr)
library(hrbrthemes)
library(Cairo)

#read csv file
PFC_Merged <- read.csv("PFC_Merged_integrated_intensity.csv")

#convert columns to numbers
PFC_Merged$col <- sprintf("%02d", as.numeric(PFC_Merged$col))
PFC_Merged$Well <- paste(PFC_Merged$row,PFC_Merged$col, sep = "")

PFC_Merged$phase <- paste(PFC_Merged$Condition, PFC_Merged$LED.trigger)

#subset for parabola and construct
p <- c(1,2,3,4)

for (i in p) {
  subset <- subset(PFC_Merged, Parabola == p[i] & Construct == "CaMPARI2-F391W" & Condition != "Histamine") 
  
  #ordering of phases in their reight timely manner
  subset$phase <- factor(subset$phase, 
                             levels = c( "Pre-Parabola 1","Pre-Parabola 2","Pull-up 1","Pull-up 2",
                                         "Zero-G 1","Zero-G 2","Pull-out 1","Pull-out 2","Post-Parabola 1","Post-Parabola 2"),
                             ordered = TRUE)
  
  subset$Condition <- factor(subset$Condition, 
                             levels = c( "Pre-Parabola","Pull-up","Zero-G","Pull-out","Post-Parabola"),
                             ordered = TRUE)
  
  #plot panels with boxplots
  boxplot <- ggplot(subset, aes(x=phase, y=IntegratedIntensity, fill=Condition)) + 
    geom_boxplot() +
    facet_wrap(~Inhibitor)+
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
      ) +
    
    ggtitle(paste0("inegrated intensity, parabola: ",p[i]))
  
  figure <- boxplot + stat_compare_means(label = "p.signif", method = "t.test",
                               ref.group = "Pre-Parabola 1",
                               label.y = 0.35, hide.ns = TRUE)
  
  #save as vector graphic in .eps format
  ggsave(filename = paste0("IntegratedIntensity_parabola",p[i],".eps"),
         plot = print(figure),
         device = cairo_ps)
}
