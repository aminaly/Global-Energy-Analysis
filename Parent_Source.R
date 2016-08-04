## Parent Script to be sourced before other files 

### General Settings ###

# dependencies 
rm(list = ls())
require(xlsx)
require(reshape2)
require(plyr)
require(plotly)
require(data.table)

# Set environment to allow data to be pushed to plot_ly
Sys.setenv("plotly_username"="amina.ly")
Sys.setenv("plotly_api_key"="7sj2jo08xg")

### Read in electricity data ### 

country <- readline("Type in which country you would like to analyze. Currently available: Democratic Republic of the Congo, 
                    Ethiopia, Turkmenistan, Myanmar, Mongolia, & Uzbekistan")

#file_location <- file.choose()
file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\ElectricStats_", 
                        country,"_08_2016_IEA.csv")
orig_data <- read.csv(file_location, header = TRUE, strip.white = TRUE)

electric_data <- orig_data

### Adjust types for NA and 0 values ###
reval <- function(y) {
  revalue(y, c("x" = NA))
  revalue(y, c("0" = 0))
  
  as.numeric(y)
}

revaled_elec <- as.data.frame(apply(electric_data[,4:71], 2, 
                                    function (y) (reval(as.character(y)))))

#Create final dataframe for use with other scripts
electric_data <- cbind(electric_data[,1:3],revaled_elec)