library(ggplot2)

#convert columns to numbers
PFC_Merged$col <- sprintf("%02d", as.numeric(PFC_Merged$col))
PFC_Merged$Well <- paste(PFC_Merged$row,PFC_Merged$col, sep = "")

#subset for parabola and construct
subset <- subset(PFC_Merged, Parabola =="1" & Construct == "CaMPARI2-F391W") 

#plot panels with boxplots
ggplot(subset, aes(x=Well, y=ConversionRate, fill=Treatment)) + 
  geom_boxplot() +
  facet_wrap(~Treatment)
