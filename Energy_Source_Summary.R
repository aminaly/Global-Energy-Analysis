## Energy Source Summaries

source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/Parent_Source.R')

# melt data for years 
renew_data <- melt(renew_data, id.vars = c("UNITS", "COUNTRY", "PRODUCT", "FLOW"))
colnames(renew_data) <- c("Unites", "COUNTRY", "PRODUCT", "FLOW", "YEAR", "SUPPLY")

renew_data <- renew_data[which(renew_data$FLOW == "Total Primary Energy Supply"),]
renew_data <- renew_data[which(renew_data$PRODUCT != "Total of All Energy Sources"),]
renew_data <- renew_data[which(renew_data$PRODUCT != "Total of Renewable Energy Sources"),]

# mark sources that stay at zero for removal
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

renewables_plot <- plot_ly(data = renew_data, x = YEAR, y = PRODUCT, z = SUPPLY, 
                           type = "scatter3d", 
                           mode = "markers", 
                           color = PRODUCT,
                           marker = list(color = "Spectral"))

renewables_plot

#plotly_POST(renewables_plot, fileopt = "overwrite", filename="DRC/Renewables", sharing = "private")

