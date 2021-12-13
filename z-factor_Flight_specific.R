# libraries
library(ggplot2)
library(ggpubr)
library(Cairo)

#read csv file
PFC_Merged <- read.csv("PFC_Merged.csv")

# set metric/readout: IntegratedIntensity, ConversionRate, Green_Red_Mean_Intensity, or RedMeanIntensity
readout = "ConversionRate"


#preparabola_BAPTA <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Pre-Parabola" & Inhibitor == "BAPTA" & LED.trigger == "1")
#preparabola_None <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Pre-Parabola" & Inhibitor == "None" & LED.trigger == "1")


# subset dataframe

negative <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Histamine" & Inhibitor == "BAPTA" & Flight == "1")

positive <- subset(PFC_Merged, Construct == "CaMPARI2-F391W" & Condition == "Histamine" & Inhibitor == "None" & Flight == "1") 

#negative$ConversionRateNormalized <- negative$ConversionRate - preparabola_BAPTA$ConversionRate
#positive$ConversionRateNormalized <- positive$ConversionRate - preparabola_BAPTA$ConversionRate

#negative1 <- subset(negative, Parabola =="1")
#negative2 <- subset(negative, Parabola =="2")
#negative3 <- subset(negative, Parabola =="3")
#negative4 <- subset(negative, Parabola =="4")

#positive1 <- subset(positive, Parabola =="1")
#positive2 <- subset(positive, Parabola =="2")
#positive3 <- subset(positive, Parabola =="3")
#positive4 <- subset(positive, Parabola =="4")


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
