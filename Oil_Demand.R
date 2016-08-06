## Used to summarize oil demand data and create visuals for plotly
## For use with countries with data taken from IEA world Energy Statistics - Oil Demand Data
## Data must be pulled from 1980-2015 (relevant for agg functions). If date range changed, adjust aggregation
source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/Parent_Source.R')

### Reformat Data ###

oil_data <- melt(oil_data, id.vars = c("COUNTRY", "FLOW (kbbl/d)", "PRODUCT"))
colnames(oil_data) <- c("COUNTRY", "FLOW (kbbl/d)", "PRODUCT", "TIME", "DEMAND")

### Aggregate every 3 years (average) ###

agg_oil <- NULL
numrows <- nrow(oil_data)

#first for loop does the same operation for each flow type
for(i in seq(1, numrows, 3)) {
  
    #separate out parts of data to be combined
    DEMAND <- mean(as.numeric(oil_data[i:(i+2),ncol(oil_data)]), na.rm = TRUE)

    #combine with correct ID values
    id_vals <- oil_data[i,1:4]
    new_row <- cbind(id_vals, as.data.frame(DEMAND))
  
    #add aggregated flow to new table
    agg_oil <- rbind(agg_oil, new_row)
}

  