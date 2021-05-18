library("bioassays")

#Summarization of flight data
summary <- dfsummary(PFCaMPARI, y = "ConversionRate",
          grp_vector = c("Treatment","Well"),
          rm_vector = "TRUE", 
          nickname = "96well",
          param = c(strict="FALSE",cutoff=40,n=12))