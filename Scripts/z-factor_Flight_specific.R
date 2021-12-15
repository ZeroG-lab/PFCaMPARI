# libraries
library(ggplot2)
library(ggpubr)
library(Cairo)

#read csv file
PFC_Merged <- read.csv("PFC_Merged.csv")

# set metric/readout: IntegratedIntensity, ConversionRate, Green_Red_Mean_Intensity, or RedMeanIntensity
readout = "ConversionRate"


# subset dataframe

negative <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Histamine" & Inhibitor == "BAPTA" & Flight == "1")

positive <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Histamine" & Inhibitor == "None" & Flight == "1") 

c <- which (colnames(negative) == readout)

# calculate means and standard deviations
mean.control <- mean(negative[ ,c])
sd.control <- sd(negative[ ,c])
mean.pos <- mean(positive[ ,c])
sd.pos <- sd(positive[ ,c])

# calculate z factor
zfactor = 1 -(3*(sd.pos+sd.control)/abs(mean.pos-mean.control))

# plot differences
zfactor <- ggplot(NULL, aes_string(x= "Inhibitor", y=readout, fill="Inhibitor", color ="Parabola" )) + 
  geom_violin(data = negative) +
  geom_violin(data = positive) +
  theme_light()+
  
  ggtitle(paste0(readout, ", z-Factor: ",zfactor))

ggsave(file = paste0("Z-Factor_flight2_ConversionRate",".pdf"), 
       plot = print(zfactor),
       device = cairo_ps)
