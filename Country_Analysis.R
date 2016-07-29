#Summary & Analysis
#For use with countries with data taken from IEA world Energy Statistics

rm(list = ls())
require(xlsx)
require(reshape2)
## read in electricity data 

country <- readline("Type in which country you would like to analyze. Currently available: DRC, 
                    Ethiopia, Turkmenistan, Myanmar, Mongolia, & Uzbekistan")

#file_location <- file.choose()
file_location <- paste0("C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\ElectricConsumption_", 
                        country,"_08_2016_IEA.csv")
orig_data <- read.csv(file_location, header = TRUE)

electric_data <- orig_data