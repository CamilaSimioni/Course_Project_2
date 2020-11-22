
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



# Subset coal combustion related summary data
combustionRelated <- grepl("comb", SCC[, SCC.Level.One], ignore.case=TRUE)
coalRelated <- grepl("coal", SCC[, SCC.Level.Four], ignore.case=TRUE) 
combustionSCC <- SCC[combustionRelated & coalRelated, SCC]
combustionsummary <- Summary[Summary[,SCC] %in% combustionSCC]

png("plot4.png")

ggplot(combustionsummary,aes(x = factor(year),y = Emissions/10^5)) +
  geom_bar(stat="identity", fill ="#FF9999", width=0.75) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

dev.off()