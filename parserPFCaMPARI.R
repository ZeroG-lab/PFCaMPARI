library(readxl)


PFCaMPARI <- data.frame()

for (k in 1:3) {
for (i in 1:8) {

  df_Flight <- read_xlsx(paste0("./Flight_", k, ".xlsx"), sheet = i)
   
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
  
  colnames(Flight)[1:2] <- c("Well", "ConversionRate")
  
  PFCaMPARI <- rbind(PFCaMPARI,Flight)
  
  rm(df_Flight, Flight, metadata)
}
  rm(i,k)
}

# added extra columns in the dataframe for 96 well plate row and column
# to make it compatible with the Bioassays package

PFCaMPARI$col <- gsub('^.', '', PFCaMPARI$Well)
PFCaMPARI$row <- substring(PFCaMPARI$Well,1 ,1)
col_order <- c("row","col","Well","ConversionRate","Flight","Unit", "Plate", "Treatment")
PFCaMPARI <- PFCaMPARI[, col_order]
