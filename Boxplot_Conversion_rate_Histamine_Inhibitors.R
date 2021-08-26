extrafont::loadfonts("win")
library(ggplot2)
library(ggpubr)
library(hrbrthemes)
library(Cairo)
library(RColorBrewer)

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
                             levels = c( "Histamine"),
                             ordered = TRUE)
  
  subset$Inhibitor <- factor(subset$Inhibitor,
                             levels = c("None", "DMSO", "Gd3+", "Ruthenium Red", "GSK2193874", "Thapsigargin", "Flunarizine", "BAPTA"))
  
  HistamineSubset<- subset(subset,Condition=="Histamine")
  HistamineSubset<- rbind(HistamineSubset,subset(subset, phase=="Pre-Parabola 1" & Inhibitor == "Thapsigargin"))
  HistamineSubset$Inhibitor<- as.character(HistamineSubset$Inhibitor)
  HistamineSubset$Inhibitor[which(HistamineSubset$phase== "Pre-Parabola 1")] <- "Thapsigargin*"
  HistamineSubset$Inhibitor<- factor(HistamineSubset$Inhibitor,
                                     levels = c("None", "DMSO", "Gd3+", "Ruthenium Red", "GSK2193874", "Thapsigargin","Thapsigargin*", "Flunarizine", "BAPTA"))
  
  
  #plot panels with boxplots
  boxplot <- ggplot(HistamineSubset, aes(x=Construct, y=ConversionRate, fill=Inhibitor)) + 
    geom_boxplot(outlier.size = 0.5, width = 0.55, position = position_dodge(width = 0.7)) +
    scale_x_discrete(expand = c(0,0.37)) +
    scale_fill_brewer(palette = "YlGnBu", direction = -1) +
    #facet_wrap(~Inhibitor)+
    theme_light()+
    theme(
      text = element_text(size=13, family= "TT Arial" ),
      plot.title = element_text(size=13),
      strip.text = element_text(color = "black"),
      axis.title.y = element_text(size=10),
      axis.title.x = element_blank(),
      axis.text.y.left = element_text("Conversion Rate"),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_text(size=10),
      legend.text = element_text(size=10),
      ) +
    
    ggtitle(paste0("Conversion Rate"))
  
  figure <- boxplot + stat_compare_means(label = "p.signif", method = "t.test",
                               ref.group = "Pre-Parabola 1",
                               label.y = 0.3, hide.ns = TRUE)
  
  #save as vector graphic in .eps format
  ggsave(filename = paste0("Conversion_Rate_Histamine",".png"), width = 12, height = 9, units = "cm", 
         plot = print(figure),
         device = png)
  
  
#}

