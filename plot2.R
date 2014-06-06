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

# Save plot as png
png(filename = "plot2.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white")

par(oma=c(2,2,2,0)); 

# create the line plot
with(usedata, plot(mydate, Global_active_power, type="l", 
                   cex.lab = 0.9, cex.axis = 0.9,
                   xlab = "", ylab = "Global Active Power (killowatts)"))



dev.off()