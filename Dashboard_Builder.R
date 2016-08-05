#Summary & Analysis
#For use with countries with data taken from IEA world Energy Statistics
#Data must be pulled from 1980-2015 (relevant for agg functions). If date range changed, adjust aggregation
source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/Parent_Source.R')

### Aggregate data for compliance with IEA licensing rules (average every three years) ###

flows <- unique(electric_data$FLOW)
uni_flow <- as.numeric(length(flows))
agg_elec_total <- NULL

#first for loop does the same operation for each flow type
for(j in 1:uni_flow) {
  
  #reset agg data frame
  agg_elec <- NULL
  
  #selectes partial data set for aggregation
  temp_flow <- as.character(flows[j])
  temp_flow_data <- electric_data[which(electric_data$FLOW == temp_flow),]
  numrows <- as.numeric(nrow(temp_flow_data))
  
  #second for loop does the actual aggregation
  for(i in seq(1, numrows, 3)) {
    
    #separate out parts of data to be combined
    to_combine <- temp_flow_data[i:(i+2),4:71]
    combined <- as.data.frame(apply(to_combine, 2, mean, na.rm = TRUE))
    
    #reformat data for combining
    setDT(combined, keep.rownames = TRUE)[]
    combined$id <- i-1
    colnames(combined) <- c("rn", "val", "id")
    combined <- dcast(combined, id ~ rn, value.var = "val")
  
    #combine with previous loops
    combined2 <- cbind(temp_flow_data[i,1:3], combined)
    agg_elec <- rbind(agg_elec, combined2)
  }
  
  #add aggregated flow to new table
  agg_elec_total <- rbind(agg_elec, agg_elec_total)
}

electric_data <- agg_elec_total
electric_data <- electric_data[order(electric_data$FLOW),]

### Summarize overal electricity output ###

#by production x total GWh
prod_gwh <- electric_data[electric_data$FLOW %in% "Production",]
prod_gwh$Electricity..GWh. <- as.numeric(prod_gwh$Electricity..GWh.)

plot_prod_gwh <- plot_ly(data = prod_gwh, x = TIME, y = Electricity..GWh., type = "scatter",
                    mode = 'markers',name = "Consumption")  %>% 
  layout(title = paste0(country,': <br>Electricity Production',
                        '<br>Source:<a href="http://data.iea.org/payment/products/118-world-energy-statistics-2016-edition.aspx">
                        World Energy Statistics 2016</a>'))
plot_prod_gwh %>% add_trace(y = fitted(loess(Electricity..GWh. ~ TIME)), x = TIME, name = "Loess Fit")

#by import v export of electricity
imp_gwh <- electric_data[electric_data$FLOW %in% "Imports",]
exp_gwh <- electric_data[electric_data$FLOW %in% "Exports",]                                                   

plot_exp_gwh <- plot_ly(exp_gwh, x = exp_gwh$TIME, y = exp_gwh$Electricity..GWh., 
                             name = "Total Exports", type = "bar", opacity = .6) %>% 
  layout(title = paste0(country,': <br>Import v Export of Electricity',
                        '<br>Source:<a href="http://data.iea.org/payment/products/118-world-energy-statistics-2016-edition.aspx">
                        World Energy Statistics 2016</a>'))
plot_imp_gwh <- add_trace(data = plot_exp_gwh, x = imp_gwh$TIME, y = imp_gwh$Electricity..GWh., type = "bar",
                          name = "Total Imports", opacity = .6)

plot_final_impex_elec <- layout(plot_imp_gwh, barmode = 'overlay')

# total electric supply
prod_gwh <- electric_data[electric_data$FLOW %in% "Production",]
dom_gwh <- electric_data[electric_data$FLOW %in% "Domestic supply",]

plot_imp_gwh2 <- plot_ly(imp_gwh, x = TIME, y = Electricity..GWh.,
                           fill = "tozeroy", name = "Imports") %>% 
  layout(title = paste0(country,': <br>Total Electric Supply',
                        '<br>Source:<a href="http://data.iea.org/payment/products/118-world-energy-statistics-2016-edition.aspx">
                        World Energy Statistics 2016</a>'))
plot_prod_gwh2 <- add_trace(data = plot_imp_gwh2, x = prod_gwh$TIME, y = prod_gwh$Electricity..GWh.,
                         fill = "tonexty", name = "Production")
plot_dom_gwh <- add_trace(plot_prod_gwh2, x = dom_gwh$TIME, y = dom_gwh$Electricity..GWh.,
                          fill = "tonexty", name = "Domestic Supply")

# where energy is used
ind_gwh <- electric_data[electric_data$FLOW %in% "Industry",]
res_gwh <- electric_data[electric_data$FLOW %in% "Residential",]

plot_res_gwh <- plot_ly(data = res_gwh, x = res_gwh$TIME, y = res_gwh$Electricity..GWh.,
                          fill = "tozeroy", name = "Residential") %>% 
                        layout(title = paste0(country,': <br>Industry v Residential Energy Use',
                               '<br>Source:<a href="http://data.iea.org/payment/products/118-world-energy-statistics-2016-edition.aspx">
                               World Energy Statistics 2016</a>'))
plot_ind_gwh <- add_trace(plot_res_gwh, x = ind_gwh$TIME, y = ind_gwh$Electricity..GWh.,
                        fill = "tonexty", name = "Industry")

plot_prod_gwh
plot_final_impex_elec
plot_dom_gwh
plot_ind_gwh

## post data to plotly account 
# uncomment the next few lines to upload

#plotly_POST(plot_prod_gwh, fileopt = "overwrite", filename="DRC/Electricity Production", sharing = "private")
#plotly_POST(plot_final_impex_elec, fileopt = "overwrite", filename="DRC/Electricity Import/Export", sharing = "private")
#plotly_POST(plot_dom_gwh, fileopt = "overwrite", filename="DRC/Total Electric Supply", sharing = "private")
#plotly_POST(plot_ind_gwh, fileopt = "overwrite", filename="DRC/Industrial v Residential Energy Use", sharing = "private")


