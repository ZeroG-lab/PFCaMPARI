library("bioassays")


#extract results of a single plate based on conditions and convert to datamatrix
plate <- subset(PFCaMPARI, Treatment=="Thapsigargin" & Flight=="2")
datamatrix <- matrix96(plate, "ConversionRate", rm="TRUE")

# heatmap
heatplate(datamatrix, "ConversionRate", size = 7.5)
