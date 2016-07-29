require(plotly)
require(reshape2)
require(reshapeGUI)
require(gWidgetsRGtk2)
require(xlsx)
require(psych)

rm(list = ls())

######## Electric Usage Analysis ########

### Total Electric Output Global
### Source: IEA
### Last Updated: 06/2016

############ Read in data ############
print("Open Total Electric Output 06_2016")
file_location <- file.choose()
orig_data <- read.csv(file_location, header = TRUE)

working <- orig_data

############ Show list of potential summarizing countries ############
summaries <- unique(working$COUNTRY)
View(as.data.frame(summaries))
selected <- readline("Which country/group would you like to summarize by? If none, and you would like to just 
                     see a global numbers, type in 'skip'")

#plot data based on selected country
# select individual country for plotting etc 
if(country == "skip") country <- "World"

#group by selected country
group <- working[working$COUNTRY %in% country,]

#save out plotting data
plotting <- plot_ly(data = group, x = TIME, y = Electricity..GWh., type = "scatter",
                    mode = 'markers',name = "Consumption", color = FLOW) 
plotting

############ Print out summary for the country ############
summaries <- as.data.frame(summaries[13:154])

for(i in 1:142) {
  
  cur_country <- summaries[i,]
  temp <- working[working$COUNTRY %in% cur_country,]
  
  desc <- describeBy(temp,group = "FLOW",mat=TRUE)
  desc <- desc[13:16,]

}

############ Post data onto my Plotly Online Account ############
#plotly_POST(plotting, fileopt = "overwrite", sharing = "public" )
