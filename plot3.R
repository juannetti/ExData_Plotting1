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
png(filename = "plot3.png")
with(data, plot(DateTime, Sub_metering_1, type = "n", xlab="", ylab = "Energy sub metering"))
with(data, lines(DateTime, Sub_metering_1, type = "l"))
with(data, lines(DateTime, Sub_metering_2, tdev.off()ype = "l", col = "orange"))
with(data, lines(DateTime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , pch = c(NA, NA, NA), col =c("black", "orange", "blue"), lwd = 1, cex = 0.8
       , lty = c(1, 1, 1))
dev.off()