## Create map with details on countries used based on metadata database
source('~/Global Energy Analysis/Project 2 - Current/EnergyAnalysis/R Files/Parent_Source.R')

file_location <- "C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\Country_Metadata.csv"
map_data <- read.csv(file_location, check.names = FALSE, strip.white = TRUE, header = TRUE)

# light grey boundaries
l <- list(color = toRGB("grey"), width = 1)

# specify map projection/options
p <- list(showframe = FALSE)

map <- plot_ly(map_data, z = ElecConsump_kWh_perCapita_2013, 
               text = Country, 
               locations = Country_Code, 
               type = 'choropleth', 
               color = ElecConsump_kWh_perCapita_2013, 
               colors = 'Blues', 
               marker = list(line = l),
               colorbar = list(titleside = "top", outlinecolor = "grey"),
               geo = p)

map
