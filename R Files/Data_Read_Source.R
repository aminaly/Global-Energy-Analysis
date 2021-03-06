### Read in electricity data ### 

country <- readline("Type in which country you would like to analyze. Currently available: 
                    World, Democratic Republic of the Congo, 
                    Ethiopia, Turkmenistan, Myanmar, Mongolia, & Uzbekistan. 
                    If you would like to keep all of the data, please type in 'All'")

#file_location <- file.choose()
file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\ElectricStats_All_08_2016_IEA.csv")
orig_data <- read.csv(file_location, header = TRUE, strip.white = TRUE)

electric_data <- orig_data
if(country != "All" || country != 'all') {
  electric_data <- electric_data[which(electric_data$COUNTRY == country),]
}

### Read in Oil Demand Data ###

file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\OilDemand_AllCountries_08_2016_IEA.csv")
orig_oil_data <- read.csv(file_location, header = TRUE, strip.white = TRUE, check.names = FALSE)

oil_data <- orig_oil_data
if(country != "All" || country != 'all') {
  oil_data <- oil_data[which(oil_data$COUNTRY == country),]
}

### Read in Renewable Data ### 

file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\RenewableStats_All_08_2016_IEA.csv")
orig_renew_data <- read.csv(file_location, header = TRUE, strip.white = TRUE, check.names = FALSE)

renew_data <- orig_renew_data
if(country != "All" || country != 'all') {
  renew_data <- renew_data[which(renew_data$COUNTRY == country),]
}

### Adjust types for NA and 0 values ###
reval <- function(y) {
  revalue(y, c("x" = NA))
  revalue(y, c("0" = 0))
  
  as.numeric(y)
}

revaled_elec <- as.data.frame(apply(electric_data[,4:71], 2, 
                                    function (y) (reval(as.character(y)))))

revaled_renew <- as.data.frame(apply(renew_data[,5:30], 2, 
                                     function (y) (reval(as.character(y)))))

#Create final dataframe for use with other scripts
electric_data <- cbind(electric_data[,1:3],revaled_elec)
renew_data <- cbind(renew_data[,1:4], revaled_renew[,1:25])