
library("data.table")
#Set a file

setwd("C:/Users/Hand 07/Desktop/Curso/Curso_4/Week_4/Course_Project_2")

arquivo <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

download.file(arquivo, destfile = "./exdata_data_NEI_data.zip", method="curl")

unzip(zipfile = "./exdata_data_NEI_data.zip", exdir = "./Pasta_2")


#Set a path

path_rf <- file.path("./Pasta_2" , "Source_Classification_Code")

files<-list.files(path_rf, recursive=TRUE)

#Power consumption data - reading, give name and subsett dataset
SCC <- data.table::as.data.table(x = readRDS(file ="./Pasta_2/Source_Classification_Code.rds"))
Summary <- data.table::as.data.table(x = readRDS(file ="./Pasta_2/summarySCC_PM25.rds"))


# Subset Summary data by Baltimore
baltimoreSummary <- Summary[fips=="24510",]

png("plot3.png")

ggplot(baltimoreSummary,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

dev.off()