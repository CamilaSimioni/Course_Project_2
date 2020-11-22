
library("data.table")
#Set a file

setwd("C:/Users/Hand 07/Desktop/Curso/Curso_4/Week_4/Course_Project_2")

arquivo <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

download.file(arquivo, destfile = "./exdata_data_NEI_data.zip", method="curl")

unzip(zipfile = "./exdata_data_NEI_data.zip", exdir = "./Pasta_2")


#Set a path

path_rf <- file.path("./Pasta_2" , "Source_Classification_Code")

files<-list.files(path_rf, recursive=TRUE)

# data reading, give name and subsett dataset
SCC <- data.table::as.data.table(x = readRDS(file ="./Pasta_2/Source_Classification_Code.rds"))
Summary <- data.table::as.data.table(x = readRDS(file ="./Pasta_2/summarySCC_PM25.rds"))



# Prevents histogram from printing in scientific notation
Summary[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalSummary <- Summary[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

png(filename='plot1.png')

barplot(totalSummary[, Emissions]
        , names = totalSummary[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")

dev.off()
                                        
                                        