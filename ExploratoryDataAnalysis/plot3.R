# JHU Exploratory Data Analysis course
# Assignment 1, plot 2
# 
# Iraklis Konstantopoulos
# Sydney, 12 April 2015
# 

# DATA INPUT
# ----------
# I only need a few dates, so find those and only read subset: 
# 1/2/2007 begins at row 66637 and 2/2/2007 ends 2880 rows later.
# Define column names as the skipping will miss that info: 
colNames <- c('Date', 'Time', 'Global_active_power', 
        'Global_reactive_power', 'Voltage', 'Global_intensity', 
        'Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')

# Read data file-separator is ';'
data <- read.table('household_power_consumption.txt', sep=';', 
                skip=66637, nrows=2880, col.names=colNames)

# Reformat dates as an R dates array
dates <- strptime(paste(data$Date, data$Time), 
                    '%d/%m/%Y %H:%M:%S', tz="EST5EDT")

# PLOT 
# ----
# Create png files of 480x480px. 
png(file = 'plot3.png', width = 480, height = 480, units = 'px')
    
# Plot 3 is a time series of all three submeters
plot(dates, data$Sub_metering_1, type='n', 
     ylab='Energy sub metering', xlab = '')
lines(dates, data$Sub_metering_1)
lines(dates, data$Sub_metering_2, col='red')
lines(dates, data$Sub_metering_3, col='blue')

# Plot legend
legend('topright', c('Sub_metering_1', 'Sub_metering_2', 
       'Sub_metering_3'), col=c('black', 'red', 'blue'),
       lty=c(1,1,1))

dev.off()