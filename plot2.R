##  install and load packages
install.packages("dplyr")
library(dplyr)

##  download file
download.file(url, destfile = "./pc_data.zip")

##  read csv
data <- read.table(unz("pc_data.zip"
  , "household_power_consumption.txt")
  , header=T
  , quote="\""
  , na.strings="?"
  , sep=";")

##  correct date formats
data <- mutate(data, Date = as.Date(Date, format = "%d/%m/%Y"))
data <- mutate(data, DateTime = paste(Date, Time, sep = ' '))

##  filter days of interest
dateBegin <- as.Date("01/02/2007", format = "%d/%m/%Y")
dateEnd <- as.Date("02/02/2007", format = "%d/%m/%Y")
data <- filter(data, Date == dateBegin | Date == dateEnd)

##  correct time formats
data$DateTime <- strptime(data$DateTime, format = "%Y-%m-%d %H:%M:%S")

##  create plot --  width, height and units requiered are default, ?png, days ticks are in spanish
png(filename = "plot2.png")
with(data, plot(DateTime, Global_active_power, type = "n", xlab="", ylab = "GlobalActive power (kilowatt)"))
with(data, lines(DateTime, Global_active_power, type = "l"))
dev.off()