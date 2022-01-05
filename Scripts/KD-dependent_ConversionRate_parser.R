#This script shows the conversion rate of five different CaMPARI2 constructs
#in relation to their respective Kd values towards Ca2+.

#load libraries
library(readxl)
library(ggplot2)
library(Cairo)
library(RColorBrewer)

#conversion rate:
df_InhibitorAssay <- read_xlsx("Data_frames//Histamine_Inhibitor_Assay_2_170122021_Exported_for_R_image_breakdown_conversion_rate.xlsx")


df_InhibitorAssay <- df_InhibitorAssay[-c(1:6),]


#construct metadata string from information in first cell
metadata <- colnames(df_InhibitorAssay[ ,1])
metadata <- unlist(strsplit(metadata, "_"))

#transpose data and convert numbers from strings to numerics
InhibAssay <- df_InhibitorAssay[ , -c(1,2)]
InhibAssay <- data.frame(t(InhibAssay))
InhibAssay$X2 <- as.numeric(InhibAssay$X2)


#delete row- and colnames
colnames(InhibAssay) <- NULL
rownames(InhibAssay) <- NULL


#rename first two unnamed columns
colnames(InhibAssay)[1:2] <- c("Well", "ConversionRate")


#Split column in well and image
InhibAssay$Image <- c(1,2,3,4)
InhibAssay$Well <- gsub(",.*$","",InhibAssay$Well)


#Add column with construct name
InhibAssay$Construct <- rep(c("CaMPARI2-F391W","CaMPARI2-F391W","CaMPARI2","CaMPARI2","CaMPARI2-H396K","CaMPARI2-H396K","CaMPARI2-F391W-G395D","CaMPARI2-F391W-G395D","CaMPARI2-L398T","CaMPARI2-L398T", "GFP","GFP"), each=2)


#Constructs as factor
InhibAssay$Construct<- factor(InhibAssay$Construct, levels = unique(InhibAssay$Construct), ordered = TRUE)


#Add column with dissociation constant
InhibAssay$KdCa <- rep(c(141,224,389,546,828,1000), each=4)


my_brewer = brewer.pal(n = 9, "YlGnBu")[3:7] #there are 9, I exluded the two lighter hues

#plot conversion rate against dissociation constant of each construct
boxplot_HisAssay <- ggplot(subset(InhibAssay,Construct!="GFP") , aes(KdCa, ConversionRate, fill=Construct))+
  geom_boxplot()+
  scale_fill_manual(values=rev(my_brewer)) +
 # scale_fill_manual(values = c("red","green","yellow","blue","orange")) +
  theme_light()+
  xlab(bquote(K[D]*Ca^"2+"*"[nM]"))+
  ylab("Conversion Rate")+
  ggtitle(bquote("KD-dependent Conversion Rate"))

#print figure
print(boxplot_HisAssay)

#save as vector image in .eps format
ggsave(filename = "Figures/KD_Histamine_Assay_ConversionRate.eps", 
       plot = print(boxplot_HisAssay),
       device = cairo_ps)


