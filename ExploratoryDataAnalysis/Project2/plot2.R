# Coursera/JHU Data Science Track: Exploratory Data Analysis
# 
# Course Project 2
# 
# Iraklis Konstantopoulos, 
# Sydney, 26 April 2015

# Question 2
# ----------
# Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
# system to make a plot answering this question.

pm25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Need to bundle by year and fips; use dplyr for speed
library(dplyr)
baltimore <- filter(pm25, fips== "24510")
xaxis <- summarise(group_by(baltimore, year))$year

yaxis <- numeric(4)
counter = 0
# Loop through all unique years and sum all emissions
for(yr in xaxis){
    counter = counter + 1
    yaxis[counter] <- sum(baltimore$Emissions[baltimore$year==yr])
}

# And plot the two
png(file = 'plot2.png')
plot(yaxis ~ xaxis, xlab='Year', ylab='Total Emissions [tons]')
dev.off()