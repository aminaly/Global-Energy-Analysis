## Parent Script to be sourced before other files 

### General Settings ###

# dependencies 
rm(list = ls())
require(xlsx)
require(reshape2)
require(plyr)
require(plotly)
require(data.table)
require(RColorBrewer)

# Set environment to allow data to be pushed to plot_ly
Sys.setenv("plotly_username"="amina.ly")
Sys.setenv("plotly_api_key"="7sj2jo08xg")

