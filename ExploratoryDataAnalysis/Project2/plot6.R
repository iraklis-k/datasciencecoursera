# Coursera/JHU Data Science Track: Exploratory Data Analysis
# 
# Course Project 2
# 
# Iraklis Konstantopoulos, 
# Sydney, 26 April 2015

# Question 5
# ----------
# Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California
# (fips == "06037"). Which city has seen greater changes over time in 
# motor vehicle emissions?

library(dplyr)

pm25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

years <- summarise(group_by(pm25, year))$year

# Consider only on-road sources. 
baltimore <- filter(pm25, type=="ON-ROAD" & fips=="24510")
losangeles <- filter(pm25, type=="ON-ROAD" & fips=="06037")

# Get the average by year
BM = numeric(4)
LA = numeric(4)
counter <- 0
for(yr in years){
    counter = counter + 1
    BM[counter] <- sum(baltimore$Emissions[baltimore$year==yr])
    LA[counter] <- sum(losangeles$Emissions[losangeles$year==yr])
}

# Combine all into a single data.frame for ggplot and melt
df <- data.frame(years, Baltimore=BM, LA)
df <- melt(df ,  id = 'years', variable_name = 'MotorVehicles')

# Plot the time series
png(file = 'plot6.png')
p <- ggplot(df, aes(years,log10(value)))
p + geom_line(aes(colour = MotorVehicles)) + 
    labs(title="Time series of vehicle-related emissions")+
    xlab("Year") + ylab("log(Total Emissions)")
dev.off()
