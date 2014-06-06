url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# create a temporary directory and temp file
tempdir = tempdir()
tempfile = tempfile(tmpdir=tempdir, fileext=".zip")

# download into the temp file
download.file(url, tempfile)

# Find the name of the file in the archive
filename = unzip(tempfile, list=TRUE)$Name[1]

# read data from the archived file into a data frame
data <- read.table(unz(tempfile, filename),  header=TRUE, sep=";", 
                   stringsAsFactors=FALSE)
unlink(tempfile)

# change the date format
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# extract needed rows from the data frame
usedata <- subset(data, Date == "2007-02-01"|Date == "2007-02-02" )

# delete the larer table to free up space

rm("data")

# create a datetime field
usedata$mydate = strptime(paste(usedata$Date, ":", usedata$Time, sep =""),
                          format='%Y-%m-%d:%H:%M:%S')

# convert the analysis variable to numeric
usedata$Global_active_power <- as.numeric(usedata$Global_active_power)
usedata$Sub_metering_1 <- as.numeric(usedata$Sub_metering_1)
usedata$Sub_metering_2 <- as.numeric(usedata$Sub_metering_2)
usedata$Sub_metering_3 <- as.numeric(usedata$Sub_metering_3)
usedata$Voltage <- as.numeric(usedata$Voltage)
usedata$Global_reactive_power <- as.numeric(usedata$Global_reactive_power)

# Save plot as png
png(filename = "plot4.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white")


# set parameter for 4 plots
par(mfcol = c(2,2))
par(mar=c(4,4,4,1));  
par(oma=c(2,2,2,0));  

# create first plot
with(usedata, plot(mydate, Global_active_power, type="l",cex.axis = 0.9, 
                   xlab = "", ylab = "Global Active Power"))

# create second plot
with(usedata, plot(mydate, Sub_metering_1, type="l", cex.axis = 0.9,
                   xlab = "", ylab = "Energy sub metering"))
with(usedata, lines(mydate, Sub_metering_2, col = "Red"))
with(usedata, lines(mydate, Sub_metering_3, col = "Blue"))
legend("topright", bty = "n", cex = 0.9, 
       c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lwd = c(1,1,1),col=c("black", "red", "blue")) 


# create third plot

with(usedata, plot(mydate, Voltage, type="l", cex.axis = 0.9,
                   xlab = "datetime", ylab = "Voltage"))

# Create 4th plot
with(usedata, plot(mydate, Global_reactive_power, type="l", cex.axis = 0.9,
                   xlab = "datetime", ylab = "Global_reactive_power"))


dev.off()