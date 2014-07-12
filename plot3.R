# Peer Assessments /Course Project 1
#========================================================
  

require(lubridate)
# http://www.r-statistics.com/2012/03/do-more-with-dates-and-times-in-r-with-lubridate-1-1-0/

#-------------------------------------------------------------------------
# Download the data, unzip the folders

# Specify the name of the url, and zipped file
my.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
my.zipfile <- "exdata-data-household_power_consumption.zip"

# Download and unzip the zipped file
download.file(url = my.url, destfile = my.zipfile)
unzip(my.zipfile)
#?unzip  # {utils} Extract of List Zip Archives

#-------------------------------------------------------------------------
### Loading the data

# Specify the name of the unzipped file
my.file <- "household_power_consumption.txt"
#list.files()

# Read in the raw file
df0.raw <- read.table(file = my.file, sep = ";", header = TRUE, stringsAsFactors = FALSE, 
                      na.strings="?", colClasses = rep("character", 7))
#?read.table

# Take a look at the data structure
#str(df0.raw)

# Remove the url from memory
rm(my.url)
rm(my.zipfile)
rm(my.file)

#-------------------------------------------------------------------------
### Modifying the data

# Take a copy of the original data [memory intensive, helps with scripting errors]
df1.full <- df0.raw

# Set the type of the numeric data
df1.full$Global_active_power <- as.numeric(as.character(df1.full$Global_active_power)) 
df1.full$Global_reactive_power <- as.numeric(as.character(df1.full$Global_reactive_power)) 
df1.full$Voltage <- as.numeric(as.character(df1.full$Voltage)) 
df1.full$Global_intensity <- as.numeric(as.character(df1.full$Global_intensity)) 
df1.full$Sub_metering_1 <- as.numeric(as.character(df1.full$Sub_metering_1)) 
df1.full$Sub_metering_2 <- as.numeric(as.character(df1.full$Sub_metering_2)) 
df1.full$Sub_metering_3 <- as.numeric(as.character(df1.full$Sub_metering_3)) 

# Confirm the data structure
#str(df1.full)

#-------------------------------------------------------------------------
### Create new date and time variables

# Create a new variable, that is a Date Time format
df1.full$DateTime <- strptime(paste(df1.full$Date, df1.full$Time), "%d/%m/%Y %H:%M:%S")
# ?strptime  # Date-time Conversion Functions to and from Character

# Create a new variable containing dates in POSIXct format
df1.full$Date.dmy <- dmy(df1.full$Date)

# Create variables for the day, month, year
df1.full$Day <- day(df1.full$Date.dmy)
df1.full$Month <- month(df1.full$Date.dmy)
df1.full$Year <- year(df1.full$Date.dmy)

# Take a look at the data structure
#str(df1.full)
#head(df1.full)

# Count the number of unique days in February 2007
#length(unique(df1.full[df1.full$Year == 2007 & df1.full$Month == 2, ]$Day))


#-------------------------------------------------------------------------
### Subset the data

# Subset  the dates 2007-02-01 and 2007-02-02. 
df2.cht <- df1.full[df1.full$Year == 2007 
                    & df1.full$Month == 2 & df1.full$Day %in% c(1, 2), ]
#df2.cht <- subset(df1.full, df1.full$Date %in% c("1/2/2007", "2/2/2007"))

# Confirm the dates
#table(df2.cht$Date)


#-------------------------------------------------------------------------
#### Plot 3 - Line Chart of Sub_Metering_1, Sub_Metering_2, Sub_Metering_3 [Thu - Sat]

# Create a call to the driver device
png(file = "plot3.png", width = 480, height = 480)

# Plot: Sub_metering_1 by DateTime, with axis titles
plot(x = df2.cht$DateTime, y = df2.cht$Sub_metering_1, 
     type = "l", col = "black", main = "", 
     xlab = "", ylab = "Energy sub metering")

# Add new points, containing Sub_metering_2
points(x = df2.cht$DateTime, y = df2.cht$Sub_metering_2, 
       type = "l", col = "green")

# Add new points, containing Sub_metering_3
points(x = df2.cht$DateTime, y = df2.cht$Sub_metering_3, 
       type = "l", col = "blue")

# Add a legend
legend("topright",  
       c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lty = c(1, 1, 1), 
       lwd = c(2.5, 2.5, 2.5), 
       col = c("black", "green", "blue"), 
       cex = 0.75) 
#?legend

# Copy the plot on screen to a PNG file (in my working directory)
#dev.copy(png, "plot3.png")
dev.off()  ## Close the png device 