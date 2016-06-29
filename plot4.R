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
png(filename = "plot4.png")
par(mfrow = c(2, 2), cex.axis = 0.6, cex.lab = 0.7, mar=c(5, 3.8, 3.5, 1.5))
with(data, plot(DateTime, Global_active_power, type = "n", xlab="", ylab = "Global Active Power"))
with(data, lines(DateTime, Global_active_power, type = "l"))
with(data, plot(DateTime, Voltage, type = "n", xlab="datetime", ylab = "Voltage"))
with(data, lines(DateTime, Voltage, type = "l"))
with(data, plot(DateTime, Sub_metering_1, type = "n", xlab="", ylab = "Energy sub metering"))
with(data, lines(DateTime, Sub_metering_1, type = "l"))
with(data, lines(DateTime, Sub_metering_2, type = "l", col = "orange"))
with(data, lines(DateTime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , pch = c(NA, NA, NA), col =c("black", "orange", "blue"), lwd = 1, cex = 0.5
       , lty = c(1, 1, 1))
with(data, plot(DateTime, Global_reactive_power, type = "n", xlab="datetime"))
with(data, lines(DateTime, Global_reactive_power, type = "l"))
dev.off()