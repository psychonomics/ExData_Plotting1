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
#### Plot 1 - Frequency Bar Chart of Global Active Power

# Create a call to the driver device
png(file = "plot1.png", width = 480, height = 480)

# Plot: Global Active Power Frequency
hist(df2.cht$Global_active_power, breaks = 12,
     xlim = c(0, 6), ylim = c(0, 1200), 
     col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
#?hist

# Copy the plot on screen to a PNG file (in my working directory)
#dev.copy(png, "plot1.png")
dev.off()  ## Close the png device 