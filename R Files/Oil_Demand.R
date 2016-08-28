# Used to create visuals from aggregated oil demand data for all analyzed countries
# For use with databases created with the Oil_Demand_Formatter file
# Does not source parent file, largely stands apart from remainder of files

### General Settings ###
source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/Parent_Source.R')

# Read in aggregated oil information
file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\OilDemand_AllCountries_08_2016_Agg.csv")
agg_oil_data <- read.csv(file_location, header = TRUE, strip.white = TRUE, check.names = FALSE)

#Read in GDP Data for inclusiong with oil demand data
file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\GDPGRowth_WorldBank_5_8_2016.csv")
GDP_Growth_Rate_data <- read.csv(file_location, header = TRUE, strip.white = TRUE, check.names = FALSE)

### Aggregate every 2 years (average) ###

agg_gdprate <- NULL
gdps <- unique(GDP_Growth_Rate_data$`Country Name`)

for(j in 1:length(gdps)) {
  
  temp <- GDP_Growth_Rate_data[which(GDP_Growth_Rate_data$`Country Name` == gdps[j]),] 
  numrows <- nrow(temp)
  agg_temp <- NULL

  for(i in seq(1, numrows, 2)) {
    
    #separate out parts of data to be combined
    Average_Rate <- mean(as.numeric(temp[i:(i+1),ncol(temp)]), na.rm = TRUE)
    
    #combine with correct ID values
    id_vals <- temp[i,1:5]
    new_row <- cbind(id_vals, as.data.frame(Average_Rate))
    
    #add aggregated flow to new table
    agg_temp <- rbind(agg_temp, new_row)
    
  }
  
  agg_gdprate <- rbind(agg_gdprate, agg_temp)
  
}

# Adjust colun names for Join
colnames(agg_gdprate) <- c("COUNTRY", "FLOW", "PRODUCT", "CODE", "TIME", "GDP_Growth_Rate")

# Join data together 
agg_gdp_oil <- join(agg_oil_data, agg_gdprate, by = c("TIME", "COUNTRY"), type = "right")

#Remove data points without x value
agg_gdp_oil$todrop <- !(is.na(agg_gdp_oil$DEMAND))
agg_gdp_oil$todrop <- !(is.na(agg_gdp_oil$GDP_Growth_Rate))

agg_gdp_oil <- agg_gdp_oil[drop(agg_gdp_oil$todrop),]

#Adjust demand values 
agg_gdp_oil$DEMAND <- agg_gdp_oil$DEMAND * 1000

colnames(agg_gdp_oil)[3] <- "Barrels per Day"
agg_gdp_oil$GDP_Growth_Rate <- as.numeric(agg_gdp_oil$GDP_Growth_Rate)


plot1 <- plot_ly(agg_gdp_oil, x = TIME, y = DEMAND, 
                type = "scatter",
                mode = "markers",
                color = COUNTRY,
                text = paste0("Oil Demand ", DEMAND),
                marker = list(color = "Dark2"),
                size = GDP_Growth_Rate)

plot1

#plotly_POST(plot1, fileopt = "overwrite", filename="Oil Demand", sharing = "private")
