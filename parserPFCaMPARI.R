getwd()
setwd("C:/Users/hamme/OneDrive/Documents/R/PFC")

df_Flight_2 <- read_xlsx("C:/Users/hamme/OneDrive/Documents/University/PhD/PFC April 2021/all flight data/Exported_Data/Flight_2.xlsx")
df_Flight_3 <- read_xlsx("C:/Users/hamme/OneDrive/Documents/University/PhD/PFC April 2021/all flight data/Exported_Data/Flight_3.xlsx")

df_Flight_2 <- df_Flight_2 [-c(1:6),]
df_Flight_3 <- df_Flight_3 [-c(1:6),]

df <- data.frame()

for (i in 1:8) {

  df_Flight_1 <- read_xlsx("C:/Users/hamme/OneDrive/Documents/University/PhD/PFC April 2021/all flight data/Exported_Data/Flight_1.xlsx")
   
  df_Flight_1 <- df_Flight_1[-c(1:6),]
 
  metadata <- df_Flight_1[1,1]
  
  Flight_1 <- df_Flight_1[ , -c(1,2)]
  
  Flight_1 <- data.frame(t(Flight_1))
  
  Flight_1$X2 <- as.numeric(Flight_1$X2)
  
  colnames(Flight_1) <- NULL
  rownames(Flight_1) <- NULL
  Flight_1$sheet <- i
  
  #Alle Informationen als eigene Spalte hinzuf?gen
  
  df <- rbind(df,Flight_1)
}
