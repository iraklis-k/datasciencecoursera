# Coursera/JHU Data Science Track: Exploratory Data Analysis
# 
# Course Project 2
# 
# Iraklis Konstantopoulos, 
# Sydney, 26 April 2015

# Question 1 
# ----------
# Have total emissions from PM2.5 decreased in the United States 
# from 1999 to 2008? Using the base plotting system, make a plot 
# showing the total PM2.5 emission from all sources for each of 
# the years 1999, 2002, 2005, and 2008.

pm25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Need to bundle by year; use dplyr for speed
library(dplyr)
xaxis <- summarise(group_by(pm25, year))$year

yaxis <- numeric(4)
counter = 0
# Loop through all unique years and sum all emissions
for(yr in xaxis){
    counter = counter + 1
    yaxis[counter] <- sum(pm25$Emissions[pm25$year==yr])
}

# And plot the two
png(file = 'plot1.png')
plot(yaxis ~ xaxis, xlab='Year', ylab='Total Emissions [tons]')
dev.off()