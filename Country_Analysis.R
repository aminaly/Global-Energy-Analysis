#Summary & Analysis
#For use with countries with data taken from IEA world Energy Statistics
#Data must be pulled from 1980-2013 (relevant for agg functions). If date range changed, adjust aggregation

rm(list = ls())
require(xlsx)
require(reshape2)
require(plyr)
require(plotly)
require(data.table)

### Read in electricity data ### 

country <- readline("Type in which country you would like to analyze. Currently available: DRC, 
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

revaled_elec <- as.data.frame(apply(electric_data[,3:71], 2, 
                                     function (y) (reval(as.character(y)))))

electric_data <- cbind(electric_data[,1:3],revaled_elec)
electric_data <- electric_data[order(electric_data$FLOW),]
numrows <- nrow(electric_data)

### Aggregate data for compliance with IEA licensing rules (average every three years) ###
agg_elec <- NULL

for(i in seq(1, numrows, 3)) {
  
  #separate out parts of data to be combined
  to_combine <- electric_data[i:(i+2),4:71]
  combined <- as.data.frame(apply(to_combine, 2, sum))
  
  #reformat data for combining
  setDT(combined, keep.rownames = TRUE)[]
  combined$id <- i-1
  colnames(combined) <- c("rn", "val", "id")
  combined <- dcast(combined, id ~ rn, value.var = "val")

  #combine with previous loops
  combined2 <- cbind(electric_data[i,1:3], combined)
  agg_elec <- rbind(agg_elec, combined2)
}

electric_data <- agg_elec

### Summarize overal electricity output ###

#by production x total GWh
prod_gwh <- electric_data[electric_data$FLOW %in% "Production",]
prod_gwh$Electricity..GWh. <- as.numeric(prod_gwh$Electricity..GWh.)

plot_prod_gwh <- plot_ly(data = prod_gwh, x = TIME, y = Electricity..GWh., type = "scatter",
                    mode = 'markers',name = "Consumption") 
plot_prod_gwh %>% add_trace(data = prod_gwh, x = TIME, y = Electricity..GWh., type = "line",
                            name = "Consumption")
plot_prod_gwh

#by import v export
imp_gwh <- electric_data[electric_data$FLOW %in% "Imports",]
exp_gwh <- electric_data[electric_data$FLOW %in% "Exports",]                                                   

plot_exp_gwh <- plot_ly(exp_gwh, x = exp_gwh$TIME, y = exp_gwh$Electricity..GWh., 
                             name = "Total Exports", type = "bar", opacity = .6)
plot_imp_gwh <- add_trace(data = plot_exp_gwh, x = imp_gwh$TIME, y = imp_gwh$Electricity..GWh., type = "bar",
                          name = "Total Imports", opacity = .6)

plot_final_impex <- layout(plot_imp_gwh, barmode = 'overlay')
plot_final_impex

# total electric supply
prod_gwh <- electric_data[electric_data$FLOW %in% "Production",]
dom_gwh <- electric_data[electric_data$FLOW %in% "Domestic supply",]

plot_imp_gwh2 <- plot_ly(imp_gwh, x = TIME, y = Electricity..GWh.,
                           fill = "tozeroy", name = "Imports")
plot_prod_gwh <- add_trace(data = plot_imp_gwh2, x = prod_gwh$TIME, y = prod_gwh$Electricity..GWh.,
                         fill = "tonexty", name = "Production")
plot_dom_gwh <- add_trace(plot_prod_gwh, x = dom_gwh$TIME, y = dom_gwh$Electricity..GWh.,
                          fill = "tonexty", name = "Domestic Supply")
plot_dom_gwh

# where energy is used
ind_gwh <- electric_data[electric_data$FLOW %in% "Industry",]
res_gwh <- electric_data[electric_data$FLOW %in% "Residential",]
com_gwh <- electric_data[electric_data$FLOW %in% "Commercial & public services",]

plot_res_gwh <- plot_ly(data = res_gwh, x = res_gwh$TIME, y = res_gwh$Electricity..GWh.,
                          fill = "tozeroy", name = "Residential")
plot_ind_gwh <- add_trace(plot_res_gwh, x = ind_gwh$TIME, y = ind_gwh$Electricity..GWh.,
                        fill = "tonexty", name = "Industry")
plot_com_gwh <- add_trace(plot_ind_gwh, x = com_gwh$TIME, y = com_gwh$Electricity..GWh.,
                          fill = "tonexty", name = "Commercial and Public Services")
plot_com_gwh

## post data to plotly account 
# uncomment the next few lines to upload
#Sys.setenv("plotly_username"="amina.ly")
#Sys.setenv("plotly_api_key"="7sj2jo08xg")

#plotly_POST(plot_prod_gwh, fileopt = "overwrite", sharing = "private" )
#plotly_POST(plot_final_impex, fileopt = "overwrite", sharing = "private" )
#plotly_POST(plot_dom_gwh, fileopt = "overwrite", sharing = "private" )
#plotly_POST(plot_com_gwh, fileopt = "overwrite", sharing = "private" )


