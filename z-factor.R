# libraries
library(ggplot2)
library(ggpubr)

#read csv file
PFC_Merged <- read.csv("PFC_Merged.csv")

# set metric/readout: IntegratedIntensity, ConversionRate, or RedMeanIntensity
readout = "IntegratedIntensity"

# subset dataframe
c <- which (colnames(PFC_Merged) == readout)
negative <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Pre-Parabola" & Inhibitor == "None") 
positive <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Histamine" & Inhibitor == "None") 

# calculate emans and standard deviations
mean.control <- mean(negative[ ,c])
sd.control <- sd(negative[ ,c])
mean.pos <- mean(positive[ ,c])
sd.pos <- sd(positive[ ,c])

# calculate z factor
zfactor = 1 -(3*(sd.pos+sd.control)/abs(mean.pos-mean.control))

# plot differences
ggplot(NULL, aes_string(x="Condition", y=readout, fill="Condition")) + 
  geom_violin(data = negative) +
  geom_violin(data = positive) +
      theme_light()+
  ggtitle(paste0(readout, ", z-Factor: ",zfactor))

