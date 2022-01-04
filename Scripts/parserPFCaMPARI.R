#This script reads raw data from the incucyte microscope and the hardware sensors
#and combines into one unified data frame for use in subsequent analyses.

#Load libraries
library(readxl)

#####READ INCUCYTE DATA#################################################################################

#prepare empty data frame for loop binding
PFCaMPARI <- data.frame()

#loop through all 3 flights
for (k in 1:3) {
  #loop through all sheets in each flight data set
  for (i in 1:8) {
    #read data
    df_Flight <- read_xlsx(paste0("IncuCyte_Flight_data/Conversion_Rate_Flight_", k, ".xlsx"), sheet = i)
    df_Flight_int_int <- read_xlsx(paste0("IncuCyte_Flight_data//integrated_intensity_Flight_", k, ".xlsx"), sheet = i)
    df_Flight_red_mean_int <- read_xlsx(paste0("IncuCyte_Flight_data//Red_Mean_Intensity_Object_Average_Flight_", k, ".xlsx"), sheet = i)
    df_Flight_Green_Red_Mean_Int <- read_xlsx(paste0("IncuCyte_Flight_data//Green+Red_Mean_Intensity_Object_Average_Flight_", k, ".xlsx"), sheet = i)
    df_Flight_Green_Red_Mean_Int_norm_Green_Mean_Int <- read_xlsx(paste0("IncuCyte_Flight_data//Green+Red_Mean_Intensity_normalized_to_Green_Flight_", k, ".xlsx"), sheet = i)
    
    
    #cut first 6 rows 
    df_Flight <- df_Flight[-c(1:6),]
    df_Flight_int_int <- df_Flight_int_int[-c(1:6),]
    df_Flight_red_mean_int <- df_Flight_red_mean_int[-c(1:6),]
    df_Flight_Green_Red_Mean_Int <- df_Flight_Green_Red_Mean_Int[-c(1:6),]
    df_Flight_Green_Red_Mean_Int_norm_Green_Mean_Int <- df_Flight_Green_Red_Mean_Int_norm_Green_Mean_Int[-c(1:6),]
    
    
    #construct metadata string from information in first cell
    metadata <- colnames(df_Flight[ ,1])
    metadata <- unlist(strsplit(metadata, "_"))
    
    #transpose data and convert numbers from strings to numerics
    Flight <- df_Flight[ , -c(1,2)]
    Flight <- data.frame(t(Flight))
    Flight$X2 <- as.numeric(Flight$X2)
    
    Flight_int_int <- df_Flight_int_int[ , -c(1,2)]
    Flight_int_int <- data.frame(t(Flight_int_int))
    Flight_int_int$X2 <- as.numeric(Flight_int_int$X2)
    
    Flight_red_mean_int <- df_Flight_red_mean_int[ , -c(1,2)]
    Flight_red_mean_int <- data.frame(t(Flight_red_mean_int))
    Flight_red_mean_int$X2 <- as.numeric(Flight_red_mean_int$X2)
    
    Flight_Green_Red_Mean_Int <- df_Flight_Green_Red_Mean_Int[ , -c(1,2)]
    Flight_Green_Red_Mean_Int <- data.frame(t(Flight_Green_Red_Mean_Int))
    Flight_Green_Red_Mean_Int$X2 <- as.numeric(Flight_Green_Red_Mean_Int$X2)
    
    Flight_Green_Red_Mean_Int_norm_Green_Mean_Int <- df_Flight_Green_Red_Mean_Int_norm_Green_Mean_Int[ , -c(1,2)]
    Flight_Green_Red_Mean_Int_norm_Green_Mean_Int <- data.frame(t(Flight_Green_Red_Mean_Int_norm_Green_Mean_Int))
    Flight_Green_Red_Mean_Int_norm_Green_Mean_Int$X2 <- as.numeric(Flight_Green_Red_Mean_Int_norm_Green_Mean_Int$X2) 
    
    #delete row- and colnames
    colnames(Flight) <- NULL
    rownames(Flight) <- NULL
    
    colnames(Flight_int_int) <- NULL
    rownames(Flight_int_int) <- NULL
    
    colnames(Flight_red_mean_int) <- NULL
    rownames(Flight_red_mean_int) <- NULL
    
    colnames(Flight_Green_Red_Mean_Int) <- NULL
    rownames(Flight_Green_Red_Mean_Int) <- NULL
    
    colnames(Flight_Green_Red_Mean_Int_norm_Green_Mean_Int) <- NULL
    rownames(Flight_Green_Red_Mean_Int_norm_Green_Mean_Int) <- NULL
  
    
    #create metadata columns and add respective metadata entries
    Flight$Flight <- gsub("^.*t", "", metadata[1])
    Flight$Unit <- gsub("^.*t", "", metadata [2])
    Flight$Board <- gsub("^.*e", "", metadata [3])
    Flight$Inhibitor <-metadata [4]
    
    #rename first two unnamed columns
    colnames(Flight)[1:2] <- c("Well", "ConversionRate")
    colnames(Flight_int_int)[1:2] <- c("Well", "IntegratedIntensity")
    colnames(Flight_red_mean_int)[1:2] <- c("Well", "RedMeanIntensity")
    colnames(Flight_Green_Red_Mean_Int)[1:2] <- c("Well", "Green_Red_Mean_Intensity")
    colnames(Flight_Green_Red_Mean_Int_norm_Green_Mean_Int)[1:2] <-  c("Well", "Green_Red_Mean_Int_norm_Green_Mean_Intensity")
    
    #add Integrated intensity, red mean intensity to Flight dataframe, rename colnames
    Flight <- cbind(Flight,Flight_int_int$IntegratedIntensity,Flight_red_mean_int$RedMeanIntensity,Flight_Green_Red_Mean_Int$Green_Red_Mean_Int, Flight_Green_Red_Mean_Int_norm_Green_Mean_Int$Green_Red_Mean_Int_norm_Green_Mean_Int)
    colnames(Flight)[c(7,8,9,10)]<- c("IntegratedIntensity", "RedMeanIntensity", "Green_Red_Mean_Intensity", "Green_Red_Mean_Intensity_norm_Green_Mean_Intensity")
   
    #bind data from previous loop to current data
    PFCaMPARI <- rbind(PFCaMPARI,Flight)

    #clean up
    rm(df_Flight, Flight, metadata)
  }
  #clean up
  rm(i,k)
}

PFCaMPARI <- PFCaMPARI[,c(1,2,7,8,9,10,3,4,5,6)]


#####READ IN HARDWARE DATA################################################################################

#prepare empty data frame for loop binding
PFC_Hardware <-data.frame()

for(k in list.files(path="Unit_data/", pattern = "^Unit.*\\.csv", full.names = TRUE)){
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
    
    
    #convert string to time
    colmean$Time <- as.POSIXct(Flight$time[i],format="%H:%M:%OS")
    
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
    rm(colmean, metastring, d1,i)
    
  }
  #bind all data from each hardware unit and flight
  PFC_Hardware <- rbind(PFC_Hardware,Flight_AVG)
  
}

#Produce metadata table for assigning parabola, construct, and led trigger number to main data
platemap <- data.frame("Well"= unique(PFCaMPARI$Well),
                       "Parabola" = rep(c(1,2,3,4),each=24),
                       "Construct" = rep(c("CaMPARI2","CaMPARI2-F391W"), each=6),
                       "LED.trigger" = c(1,2),
                       "Condition" = ""
)


#Assign G-Phase conditions to platemap
platemap$Construct[grep("A2|A8|C2|C8|E2|E8|G2|G8", platemap$Well)] <- "GFP"
platemap$LED.trigger[grep("[ACEG][1278]$", platemap$Well)] <- NA
platemap$Condition[grep("[ACEG][17]$", platemap$Well)] <- "Histamine"
platemap$Condition[grep("[ACEG](10|[23489])", platemap$Well)] <- "Pre-Parabola"
platemap$Condition[grep("[ACEG](10|[23489])", platemap$Well)] <- "Pre-Parabola"
platemap$Condition[grep("[ACEG](5|6|11|12)", platemap$Well)] <- "Pull-up"
platemap$Condition[grep("[BDFH][1278]$", platemap$Well)] <- "Zero-G"
platemap$Condition[grep("[BDFH](10|[349])", platemap$Well)] <- "Pull-out"
platemap$Condition[grep("[BDFH](5|6|11|12)", platemap$Well)] <- "Post-Parabola"




#####MERGE INCUCYTE DATA WITH HARDWARE DATA#########################################################


#Merge data frames and keep all entries
PFC_Merged <- merge(PFCaMPARI, PFC_Hardware, all = TRUE)

PFC_Merged <- merge(PFC_Merged, platemap, all = TRUE)

#Correct Ruthenium Red/ GSK2193874 treatment
PFC_Merged$Inhibitor <- gsub("RuthRed|RutheniumRed", "Ruthenium Red", PFC_Merged$Inhibitor)
PFC_Merged$Inhibitor <- gsub("GSK219", "GSK2193874", PFC_Merged$Inhibitor)

#Rename Inhibitor treatments
PFC_Merged$Inhibitor <- gsub("untreated", "None" ,PFC_Merged$Inhibitor)

#OPTIONAL: Add identifier columns for BioAssays package
PFC_Merged$col <- gsub('^.', '', PFC_Merged$Well)
PFC_Merged$row <- substring(PFC_Merged$Well,1 ,1)
PFC_Merged <- PFC_Merged[, c(26,25,1:4,10,19:24,5:9,11:18)]

#Order wells, change data-types
PFC_Merged$col <- as.numeric(PFC_Merged$col)
PFC_Merged$Well <- factor(PFC_Merged$Well, levels=platemap$Well, ordered=TRUE)
PFC_Merged$Parabola <- as.character(PFC_Merged$Parabola)
PFC_Merged$LED.trigger <- as.character(PFC_Merged$LED.trigger)

#Write out data
write.csv(PFC_Merged, "Data_frames//PFC_Merged.csv", quote = FALSE, row.names = FALSE)
