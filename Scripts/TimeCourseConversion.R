library(readxl)
library(hrbrthemes)
library(Cairo)
library(ggplot2)
library(tidyverse)
library(investr)

#read data and rename columns
timecourse_conversion <- read_excel("Z:/Labfolder/Lab308/Hammer_Andreas/Results/PFC_April_2021/Paper Writing/Figures/Timecourse_Conversion/+Histamine/Timecourse_conversion_raw.xlsx", col_names = FALSE)
colnames(timecourse_conversion) <- c("Time","Ratio")

#calculate a non-linear regression model
model <- nls(Ratio~a*Time/(b+Time), start=c(a=1.8,b=5), data= timecourse_conversion )
new.data <- data.frame(Time=seq(0, 35, by = 0.1))
interval <- as_tibble(predFit(model, newdata = new.data, interval = "confidence", level= 0.9)) %>% 
  mutate(Time = new.data$Time)

#ggplot the timecourse data
p1 <- ggplot(timecourse_conversion, aes(x=Time, y=Ratio)) + 
  xlab("Illumination time [s]")+
  ylab("Red-to-green ratio [AU]")

#add the calculated confidence interval
p1+
  geom_line(data=interval, aes(x = Time, y = fit ), size = 1, color="black")+
  geom_ribbon(data=interval, aes(x=Time, ymin=lwr, ymax=upr), alpha=0.5, inherit.aes=F, fill="#FFE906")+
  geom_point(data=timecourse_conversion, size=3)+
  theme_light()+
  theme(
    text = element_text(size=18, family= "Arial" ),
    plot.title = element_text(size=13),
    strip.text = element_text(color = "black"),
  )