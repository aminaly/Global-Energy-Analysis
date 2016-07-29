## For creating test data
rm(list = ls())
require(xlsx)
require(reshape2)
## read in electricity data 

#file_location <- file.choose()
file_location <- "C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\TotalElectricOutput_06_2016_IEA.csv"
orig_data <- read.csv(file_location, header = TRUE)

electric_data <- orig_data

#sort out only final consumption data
final_cons <- electric_data[which(electric_data$FLOW == "Final consumption"),]

#cast data so years are their own row of data
final_cons <- dcast(final_cons, COUNTRY ~ TIME)
final_cons <- final_cons[,1:55]

#create column with growth rate from 1990-2013
final_cons$longYear <- apply(final_cons, 1, 
                             function (x) (((as.numeric(x[55]) / as.numeric(x[32]) ) ^ (1/10)) -1))

#create column with growth rate from 2008-2013
final_cons$fiveYear <- apply(final_cons, 1, 
                             function (x) (((as.numeric(x[55]) / as.numeric(x[50]) ) ^ (1/10)) -1))

#create column with growth rate from 2012-2013
final_cons$oneYear <- apply(final_cons, 1, 
                             function (x) (((as.numeric(x[55]) / as.numeric(x[54]) ) ^ (1/10)) -1))

#create column with average growth rate from all three above 
final_cons$avgRate <- apply(final_cons[,56:58], 1, mean)

#order by average growth rate from three create columns
final_cons <- final_cons[order(final_cons$fiveYear, decreasing = TRUE),]
  
# write out data
write.xlsx2(final_cons,"C:\\Users\\Amina\\Documents\\Global Energy Analysis\\SIRF 2016\\Notes & Data.xlsx",
            sheetName = "Elec Consump Data", append = TRUE)
