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

##  filter days of interest
dateBegin <- as.Date("01/02/2007", format = "%d/%m/%Y")
dateEnd <- as.Date("02/02/2007", format = "%d/%m/%Y")
data <- filter(data, Date == dateBegin | Date == dateEnd)

##  correct time formats
data$Time <- strptime(data$Time, format = "%H:%M:%S")

##  create plot --  width, height and units requiered are default, ?png
png(filename = "plot1.png")
with(data, hist(Global_active_power
  , col = "red"
  , main = "Global Active Power"
  , xlab="Global Active Power (kilowatts)"))
dev.off()