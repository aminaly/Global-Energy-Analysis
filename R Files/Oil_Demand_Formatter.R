## Used to summarize and aggregate oil demand data for individual countries 
## For use with countries with data taken from IEA world Energy Statistics - Oil Demand Data
## Data must be pulled from 1980-2015 (relevant for agg functions). If date range changed, adjust aggregation
source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/R Files/Parent_Source.R')
source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/R Files/Data_Read_Source.R')

### Reformat Data ###

oil_data <- melt(oil_data, id.vars = c("COUNTRY", "FLOW (kbbl/d)", "PRODUCT"))
colnames(oil_data) <- c("COUNTRY", "FLOW (kbbl/d)", "PRODUCT", "TIME", "DEMAND")

### Adding column for growth rate from the previous year ###
oil_data$Growth_Rate <- NA
oil_data$DEMAND <- as.numeric(oil_data$DEMAND)
for (i in 1:(nrow(oil_data)-1)) {
  
  oil_data[i+1,6] <- (((oil_data[i+1,5]/oil_data[i,5])^(.1)) - 1) 
  
}

### Aggregate every 2 years (average) ###

agg_oil <- NULL
numrows <- nrow(oil_data)

#first for loop does the same operation for each flow type
for(i in seq(1, numrows, 2)) {
  
    #separate out parts of data to be combined
    DEMAND <- mean(as.numeric(oil_data[i:(i+1),ncol(oil_data)]), na.rm = TRUE)

    #combine with correct ID values
    id_vals <- oil_data[i,1:4]
    new_row <- cbind(id_vals, as.data.frame(DEMAND))
  
    #add aggregated flow to new table
    agg_oil <- rbind(agg_oil, new_row)
}

write.xlsx(agg_oil, paste0('C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\Temp Oil Demand\\',country,".xlsx"))
  