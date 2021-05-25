#Load libraries
library(readxl)

#prepare empty data frame for loop binding
PFCaMPARI <- data.frame()

#loop through all 3 flights
for (k in 1:3) {
#loop through all sheets in each flight data set
  for (i in 1:8) {
    #read data
    df_Flight <- read_xlsx(paste0("./Flight_", k, ".xlsx"), sheet = i)
    #cut first 6 rows 
    df_Flight <- df_Flight[-c(1:6),]
    
    #construct metadata string from information in first cell
    metadata <- colnames(df_Flight[ ,1])
    metadata <- unlist(strsplit(metadata, "_"))
    
    #transpose data and convert numbers from strings to numerics
    Flight <- df_Flight[ , -c(1,2)]
    Flight <- data.frame(t(Flight))
    Flight$X2 <- as.numeric(Flight$X2)
    
    #delete row- and colnames
    colnames(Flight) <- NULL
    rownames(Flight) <- NULL
    
    #create metadata columns and add respective metadata entries
    Flight$Flight <- gsub("^.*t", "", metadata[1])
    Flight$Unit <- gsub("^.*t", "", metadata [2])
    Flight$Plate <- gsub("^.*e", "", metadata [3])
    Flight$Treatment <-metadata [4]
    
    #rename first two unnamed columns
    colnames(Flight)[1:2] <- c("Well", "ConversionRate")
    
    #bind data from previous loop to current data
    PFCaMPARI <- rbind(PFCaMPARI,Flight)
    
    #clean up
    rm(df_Flight, Flight, metadata)
  }
  #clean up
  rm(i,k)
}

# added extra columns in the dataframe for 96 well plate row and column
# to make it compatible with the Bioassays package

PFCaMPARI$col <- gsub('^.', '', PFCaMPARI$Well)
PFCaMPARI$row <- substring(PFCaMPARI$Well,1 ,1)
col_order <- c("row","col","Well","ConversionRate","Flight","Unit", "Plate", "Treatment")
PFCaMPARI <- PFCaMPARI[, col_order]


#prepare empty data frame for loop binding
PFC_Hardware <-data.frame()

for(k in list.files(path="./", pattern = "\\.csv", full.names = TRUE)){
  print(paste("working on",k))

Flight <- read.csv(k, sep=";", header=TRUE)

#prepare empty data frame for loop binding
Flight_AVG<-data.frame()
 
#loop through all rows, that have an LED ON event 
for (i in grep("LED ON",Flight$event)) {
  
  #average the measurements of the 8 second sequence
  colmean<-data.frame(t(colMeans(Flight[i:(i+399),-c(1,11,12)])))
 
  #construct string with metadata information about well and board position
  metastring <- unique(gsub("Board: ", "", unlist(strsplit(unlist(strsplit(gsub("LEDs off, ", "", Flight$event[i]), split = ", ")), split = " LED ON "))))
 
  #add metadata to the averaged measurements
  colmean$Board <- paste(metastring[1])
  colmean$Well <- paste(metastring[2])
 
  #prepare time string for correction by splitting it up
  timestring <- unlist(strsplit(Flight$time[i], split = ":"))
 
  #if there is a single-digit minute value, add a zero. If not, ignore.
  if(nchar(timestring[2]) == 1) {
   timestring[2] <- paste0(0, timestring[2])
  }else{}
 
  #collapse the split and corrected time string back into the time column
  colmean$Time <-  paste(timestring, collapse = ":")
  #convert string to time
  Flight$time <- as.POSIXct(Flight$time,format="%H:%M:%OS")
  #Add column "Unit" with 101/102/103/104  to Flight_AVG dataframe
  d1 <- read.table(text=gsub("^.*it|Flight|.csv", "", k),
                   sep = "_", col.names = c("Unit" , "Flight"))
  
  colmean <- cbind(colmean, d1)
  
  #add a new row of duplicated data for each board and well and paste the corresponding metadata to it
  colmean <- rbind(colmean,colmean[1,])
  colmean$Board[2] <- paste(metastring[1])
  colmean$Well[2] <- paste(metastring[3])
 
  colmean <- rbind(colmean,colmean[1,])
  colmean$Board[3] <- paste(metastring[4])
  colmean$Well[3] <- paste(metastring[2])
 
  colmean <- rbind(colmean,colmean[1,])
  colmean$Board[4] <- paste(metastring[4])
  colmean$Well[4] <- paste(metastring[3])
 
  #produce human-readable column names for the finished data set
  colnames(colmean)[1:9] <- c("Temp.Board.1", "Temp.Board.2", "Temp.LED", "Pressure.mbar", "Gravity.X.mg", "Gravity.Y.mg", "Gravity.Z.mg", "Supply.U.mV", "Supply.I.mA")
 
  #bind the data from the previous loop with data from this loop to generate the final data frame
  Flight_AVG<-rbind(Flight_AVG,colmean)
  
  #correct column names if necessary
  colnames(Flight_AVG)<-colnames(colmean)
  
  
  #clean up
  rm(colmean, metastring, timestring,i)

}

PFC_Hardware <- rbind(PFC_Hardware,Flight_AVG)

}

