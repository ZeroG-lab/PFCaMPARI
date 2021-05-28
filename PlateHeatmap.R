# libraries
library("bioassays")

# Read data file
PFC_Merged <- read.csv("PFC_Merged.csv")

# extract vector with flights and Inhibitors from dataframe
flights <- unique(PFC_Merged$Flight)
chemicals <- unique(PFC_Merged$Inhibitor)

# plot pdf file with heatmaps
pdf("Heatmaps.pdf")

for(j in 1:8) {
  for(i in 1:3) {
    # make subsets of the data frame based on flight days and inhibitors, so that each plate can be plotted separately
    plate <- subset(PFC_Merged, Inhibitor == chemicals[j] & Flight == flights[i])
    # generate a datamatrix for the heatplate function
    datamatrix <- matrix96(plate, "ConversionRate", rm="TRUE")
    # heatmap
    plot(heatplate(datamatrix, paste0("Flight: ", flights[i], ", Inhibitor: ", chemicals [j]), size = 10))
  }
}
dev.off()

