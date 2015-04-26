# Coursera/JHU Data Science Track: Exploratory Data Analysis
# 
# Course Project 2
# 
# Iraklis Konstantopoulos, 
# Sydney, 26 April 2015

# Question 5
# ----------
# How have emissions from motor vehicle sources changed from 
# 1999–2008 in Baltimore City?

library(dplyr)

# pm25 <- readRDS("summarySCC_PM25.rds")
# SCC <- readRDS("Source_Classification_Code.rds")

years <- summarise(group_by(pm25, year))$year

# Consider only on-road sources. 
df <- filter(pm25, type=="ON-ROAD" & fips=="24510")

# Get the average by year
emissions = numeric(4)
counter <- 0
for(yr in years){
    counter = counter + 1
    emissions[counter] <- sum(df$Emissions[df$year==yr])
}

# Combine all into a single data.frame for ggplot and melt
df <- data.frame(years, emissions)
df <- melt(df ,  id = 'years', variable_name = 'MotorVehicles')

# Plot the time series
png(file = 'plot5.png')
p <- ggplot(df, aes(years,log10(value)))
p + geom_line(aes(colour = MotorVehicles)) + 
    labs(title="Time series of vehicle-related emissions in Baltimore")+
    xlab("Year") + ylab("log(Total Emissions)")
dev.off()
