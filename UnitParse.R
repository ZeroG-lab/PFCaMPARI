# Libraries
library(ggplot2)
library(dplyr)
library(plotly)
library(hrbrthemes)
library(readr)
library(htmlwidgets)

#load dataset
Unit101_Flight2 <- read_delim("Unit101_Flight2.csv",
                              ";", escape_double = FALSE,
                              trim_ws = TRUE)

# Load dataset from github
data <- Unit101_Flight2

# Usual ggplot line chart
p <- data %>%
  ggplot( aes(x=time)) +
  geom_line(aes_string(y=data$`gravity z [mg]`),color="darkred") +
  geom_line(aes_string(y=data$`supply I [mA]`),color="steelblue", linetype="twodash") +
  ylab("gravity [mg]") +
  theme_ipsum()

# Turn it interactive with ggplotly
p <- ggplotly(p)

# save the widget
saveWidget(p, file=paste0( getwd(),"/Unit_data/Unit101_Flight2.html"))
