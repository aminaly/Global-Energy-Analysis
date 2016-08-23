## Energy Source Summaries

source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/Parent_Source.R')

### Melt data for years label ###
renew_data <- melt(renew_data, id.vars = c("UNITS", "COUNTRY", "PRODUCT", "FLOW"))
colnames(renew_data) <- c("Unites", "COUNTRY", "PRODUCT", "FLOW", "YEAR", "SUPPLY")

renew_data <- renew_data[which(renew_data$FLOW == "Total Primary Energy Supply"),]
renew_data <- renew_data[which(renew_data$PRODUCT != "Total of All Energy Sources"),]
renew_data <- renew_data[which(renew_data$PRODUCT != "Total of Renewable Energy Sources"),]

### Mark sources that stay at zero for removal ###
sources <- unique(renew_data$PRODUCT)
rebuild <- NULL

for(i in 1:length(sources)) {
  
  test_prod <- renew_data[which(renew_data$PRODUCT == sources[i]),]
  if(sum(test_prod$SUPPLY) == 0) { 
    test_prod$toKeep <- FALSE 
    
  } else {
      
    test_prod$toKeep <- TRUE
    
  }
  
  test_prod$colorNum <- i/10
  rebuild <- rbind(test_prod, rebuild)
  
}

renew_data <- rebuild
renew_data <- renew_data[drop(renew_data$toKeep),]

### Aggregate remaining data by every three years ###
sources <- unique(renew_data$PRODUCT)
num_loops <- as.numeric(length(sources))
agg_renew_total <- NULL

for(j in 1:num_loops) {
  
  #reset agg data frame 
  agg_renew <- NULL
  
  temp_cat <- as.character(sources[j])
  temp <- renew_data[which(renew_data$PRODUCT == temp_cat),]
  numrows <- nrow(temp)
  temp$agg_supply <- NA
  
  for(i in seq(1, numrows, 2)){
    
    mean_val <- mean(temp[i:(i+1),6])
    temp[i,9] <- mean_val
    
  }
  
  agg_renew_total <- rbind(agg_renew_total, temp)

}

renew_data <- agg_renew_total[which(agg_renew_total$agg_supply > 0),]

renewables_plot <- plot_ly(data = renew_data, x = YEAR, y = PRODUCT, z = agg_supply, 
                           type = "scatter3d", 
                           mode = "line", 
                           color = PRODUCT,
                           marker = list(color = "Spectral"))

renewables_plot

plotly_POST(renewables_plot, fileopt = "overwrite", filename="DRC/Renewables", sharing = "private")

