
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



# Gather the subset of the summary data which corresponds to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclessummary <- Summary[Summary[, SCC] %in% vehiclesSCC,]

# Subset the vehicles summary data to Baltimore's fip
baltimoreVehiclessummary <- vehiclessummary[fips=="24510",]

png("plot5.png")

ggplot(baltimoreVehiclessummary,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill ="#FF9999" ,width=0.75) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

dev.off()