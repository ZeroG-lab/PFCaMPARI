#This script calculates and plots the Z'-factor for the conversion rate of
#cells with a histamine-induced calcium increase after either no treatment
#(positive control) or BAPTA treatment (negative control).

#load libraries
library(ggplot2)
library(ggpubr)
library(Cairo)

#read csv file
PFC_Merged <- read.csv("Data_frames/PFC_Merged.csv")

#set metric/readout: IntegratedIntensity, ConversionRate, Green_Red_Mean_Intensity, or RedMeanIntensity
readout = "ConversionRate"


#create negative and positive control data frames for calculating Z'-factor
#change flight to either 1,2 or 3
negative <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Histamine" & Inhibitor == "BAPTA" & Flight == "1")
positive <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Histamine" & Inhibitor == "None" & Flight == "1") 

#calculate means and standard deviations
c <- which (colnames(negative) == readout)
mean.control <- mean(negative[ ,c])
sd.control <- sd(negative[ ,c])
mean.pos <- mean(positive[ ,c])
sd.pos <- sd(positive[ ,c])

#calculate Z'-factor
zfactor = 1 -(3*(sd.pos+sd.control)/abs(mean.pos-mean.control))

#plot Z'-factor
zfactor <- ggplot(NULL, aes_string(x= "Inhibitor", y=readout, fill="Inhibitor", color ="Parabola" )) + 
  geom_violin(data = negative) +
  geom_violin(data = positive) +
  theme_light()+
  
  ggtitle(paste0(readout, ", z-Factor: ",zfactor))

#save as vector image in .eps format
ggsave(file = paste0("Figures/Z-Factor_flight1_ConversionRate",".eps"), 
       plot = print(zfactor),
       device = cairo_ps)
