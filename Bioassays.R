library("bioassays")


#heatmap
df <- (data_DF1)
datamatrix <- matrix96(df, "value")

heatplate(datamatrix, "Values", size = 7.5)


# summarization
data(metafile384, rawdata384)
rawdata<-plate2df(data2plateformat(rawdata384,platetype = 384))
data_DF2<- dplyr::inner_join(rawdata,metafile384,by=c("row","col","position"))

## eg:1 summarising the'value'after grouping samples and omitting blanks
# grouping order cell, compound, concentration and type.
result2 <- dfsummary(data_DF2,y = "value",
                     grp_vector = c("cell","compound","concentration","type"),
                     rm_vector = c("blank1","blank2","blank3","blank4"),
                     nickname = "384well",
                     rm = "FALSE",param = c(strict="FALSE",cutoff=40,n=12))

