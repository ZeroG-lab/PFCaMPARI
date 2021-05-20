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


# Import Hardware flight data: 50 sets per second,
# 8 second for every event -> 400 entries per illumination

# Step One: Delete Entries till the first event

Unit101_Flight1 <- read.csv2("./Unit101_Flight1.csv", header=TRUE)

#extract column information from first trigger to first stop

event1 <- Unit101_Flight1$event[c(1:200),]

event1 <- Unit101_Flight1$event[c(".*LED ON*":".*LEDs off"),]

event1 <- Unit101_Flight1[c("Board: 1 LED ON H9, Board: 1 LED ON H3, Board: 2 LED ON H9, Board: 2 LED ON H3":"LEDs off, Board: 1 LED ON H12, Board: 1 LED ON H6, Board: 2 LED ON H12, Board: 2 LED ON H6
"),]

