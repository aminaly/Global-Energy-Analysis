## For creating test data
rm(list = ls())
require(xlsx)
## read in electricity data 

#file_location <- file.choose()
file_location <- "C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\TotalElectricOutput_06_2016_IEA.csv"
orig_data <- read.csv(file_location, header = TRUE)

electric_data <- orig_data

## read in GDP Data
file_location <- "C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\GDPGrowth_WorldBank_5_8_2016.xls"
orig_gdp_data <- read.xlsx2(file_location, 2, header = TRUE)
GDP_Growth <- orig_gdp_data

orig_class_data <- read.xlsx(file_location, 3, header = TRUE)
Country_classif <- orig_class_data

## Format GDP Data
GDP_Growth <- GDP_Growth[,c(1:2,45:59)]

## Conbine growth data and classification based on country code
GDP_class_comb <- merge(GDP_Growth, Country_classif, by = "Country.Code")

##Pick out middle and lower income groups, and order by GPD growth
GDP_class_comb <- GDP_class_comb[which(GDP_class_comb$IncomeGroup != "High income: nonOECD"),]
GDP_class_comb <- GDP_class_comb[which(GDP_class_comb$IncomeGroup != "High income: OECD"),]

# Uncomment below lines if only want complete cases
#complete.cases(GDP_class_comb)
#GDP_class_comb <- GDP_class_comb[complete.cases(GDP_class_comb),]

# add up growth over most recent 5 years 
past5 <- apply(GDP_class_comb[,12:17], 1, mean, na.rm = TRUE)
GDP_class_comb <- cbind(GDP_class_comb, as.data.frame(past5))
added <- apply(GDP_class_comb[,c(17,22)], 1, sum, na.rm = TRUE)
GDP_class_comb <- cbind(GDP_class_comb, as.data.frame(added))

# order by 2014 GDP growth & past 5 years of data
GDP_class_2014 <- GDP_class_comb[order(GDP_class_comb$added, decreasing = TRUE),]

# write out data
write.xlsx2(GDP_class_2014,"C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\Notes & Data.xlsx",
            sheetName = "GDP Growth Data", append = TRUE)


