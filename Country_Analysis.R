#Summary & Analysis
#For use with countries with data taken from IEA world Energy Statistics

rm(list = ls())
require(xlsx)
require(reshape2)
require(plyr)
require(plotly)

#read in electricity data 

country <- readline("Type in which country you would like to analyze. Currently available: DRC, 
                    Ethiopia, Turkmenistan, Myanmar, Mongolia, & Uzbekistan")

#file_location <- file.choose()
file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\ElectricConsumption_", 
                        country,"_08_2016_IEA.csv")
orig_data <- read.csv(file_location, header = TRUE)

electric_data <- orig_data

#replace any "x" with an NA
reval <- function(y) {
  revalue(y, c("x" = NA))
}

electric_data <- as.data.frame(apply(electric_data, 2, 
                                     function (y) (reval(as.character(y)))))

#aggregate data for compliance with IEA licensing rules (average every three years)

### summarize overal electricity output ###

#by production x total GWh
prod_gwh <- electric_data[electric_data$FLOW %in% "Production",]
prod_gwh$Electricity..GWh. <- as.numeric(prod_gwh$Electricity..GWh.)

plot_prod_gwh <- plot_ly(data = prod_gwh, x = TIME, y = Electricity..GWh., type = "scatter",
                    mode = 'markers',name = "Consumption") 
plot_prod_gwh %>% add_trace(data = prod_gwh, x = TIME, y = Electricity..GWh., type = "line"
                            ,name = "Consumption")
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

# total electricity available


# summarize electricity usage by source type

