library(ggplot2)
library(dplyr)

#Download & unzip data
zip_data <- "electric_power_consumption.zip"

if (!file.exists(zip_data)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, zip_data, method="curl")
}  
if (!file.exists("ConsumptionPlots")) { 
    unzip(zip_data) 
}

# Read Data
consumption <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", 
                          stringsAsFactors=FALSE, dec=".")
# Keep only dates 2007-02-01 and 2007-02-02 (dplyr package)
consumption <-filter(consumption, Date == "1/2/2007" | Date =="2/2/2007")

# Create new variable with date and time
consumption$datetime <- strptime(paste(consumption$Date, consumption$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 

# Plot3
# convert datetime variable
consumption$datetime <- as.POSIXct(consumption$datetime)
par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE, bg=NA)
par(bg=NA) # transparent backround
with(consumption, {
    plot(Sub_metering_1~datetime, type="l",
         ylab="Global Active Power (kilowatts)", xlab="")
    lines(Sub_metering_2~datetime,col='Red')
    lines(Sub_metering_3~datetime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2,
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, "plot3.png", width = 480, height = 480)
dev.off()
