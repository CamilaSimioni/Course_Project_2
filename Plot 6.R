
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

# Subset the vehicles summary data by each city's fip and add city name.
vehiclesBaltimoresummary <- vehiclessummary[fips == "24510",]
vehiclesBaltimoresummary[, city := c("Baltimore City")]

vehiclesLAsummary <- vehiclessummary[fips == "06037",]
vehiclesLAsummary[, city := c("Los Angeles")]

# Combine data.tables into one data.table
bothsummary <- rbind(vehiclesBaltimoresummary,vehiclesLAsummary)

png("plot6.png")

ggplot(bothsummary, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

dev.off()