#This script plots the time-dependent conversion of the CaMPARI2F391W-G395D
#construct after treatment with histamine against increasing durations of 
#illumination with 405 nm conversion light.

#load libraries
library(readxl)
library(hrbrthemes)
library(Cairo)
library(ggplot2)
library(tidyverse)
library(investr)

#read data and rename columns
timecourse_conversion <- read_excel("Data_frames/Timecourse_conversion_raw.xlsx", col_names = FALSE)
colnames(timecourse_conversion) <- c("Time","Ratio")

#calculate a non-linear regression model
model <- nls(Ratio~a*Time/(b+Time), start=c(a=1.8,b=5), data= timecourse_conversion )
new.data <- data.frame(Time=seq(0, 35, by = 0.1))
interval <- as_tibble(predFit(model, newdata = new.data, interval = "confidence", level= 0.9)) %>% 
  mutate(Time = new.data$Time)

#plot the time course data
figure <- ggplot(timecourse_conversion, aes(x=Time, y=Ratio)) + 
  xlab("Illumination time [s]")+
  ylab("Red-to-green ratio [AU]")+
  geom_line(data=interval, aes(x = Time, y = fit ), size = 1, color="black")+
  geom_ribbon(data=interval, aes(x=Time, ymin=lwr, ymax=upr), alpha=0.5, inherit.aes=F, fill="#FFE906")+
  geom_point(data=timecourse_conversion, size=3)+
  theme_light()+
  theme(
    text = element_text(size=18, family= "Arial" ),
    plot.title = element_text(size=13),
    strip.text = element_text(color = "black"),
  )
#print figure
print(figure)

#save as vector image in .eps format
ggsave(filename = "Figures/TimeCourseConversion.eps",
       plot = print(figure),
       device = cairo_ps)