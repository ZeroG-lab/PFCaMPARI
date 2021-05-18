getwd()
setwd("C:/Users/hamme/OneDrive/Documents/R/PFC")

library(readxl)



PFCaMPARI <- data.frame()

for (k in 1:3) {
for (i in 1:8) {

  df_Flight <- read_xlsx(paste0("C:/Users/hamme/OneDrive/Documents/University/PhD/PFC April 2021/all flight data/Exported_Data/Flight_", k, ".xlsx"), sheet = i)
   
  df_Flight <- df_Flight[-c(1:6),]
 
  metadata <- colnames(df_Flight[ ,1])
  metadata <- unlist(strsplit(metadata, "_"))
  
  
  
  
  Flight <- df_Flight[ , -c(1,2)]
  
  Flight <- data.frame(t(Flight))
  
  Flight$X2 <- as.numeric(Flight$X2)
  
  
  
  colnames(Flight) <- NULL
  rownames(Flight) <- NULL
  
  Flight$Flight <- gsub("^.*t", "", metadata[1])
  Flight$Unit <- gsub("^.*t", "", metadata [2])
  Flight$Plate <- gsub("^.*e", "", metadata [3])
  Flight$Treatment <-metadata [4]
  
  PFCaMPARI <- rbind(PFCaMPARI,Flight)
}
}

colnames(PFCaMPARI)[1:2] <- c("Well", "ConversionRate")
