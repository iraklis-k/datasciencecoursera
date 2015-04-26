# Coursera/JHU Data Science Track: Exploratory Data Analysis
# 
# Course Project 2
# 
# Iraklis Konstantopoulos, 
# Sydney, 26 April 2015

# Question 3
# ----------
# Of the four types of sources indicated by the type (point, nonpoint, 
# onroad, nonroad) variable, which of these four sources have seen 
# decreases in emissions from 1999–2008 for Baltimore City? Which have 
# seen increases in emissions from 1999–2008? Use the ggplot2 plotting 
# system to make a plot answer this question.

library(ggplot2)
library(dplyr)
library(reshape)

pm25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

years <- summarise(group_by(pm25, year))$year

# Save subsets for plot
em1 <- filter(pm25, type=="NON-ROAD")
em2 <- filter(pm25, type=="NONPOINT")
em3 <- filter(pm25, type=="ON-ROAD")
em4 <- filter(pm25, type=="POINT")

# Make some shells for time sequences
nonRoad <- numeric(4)
nonPoint <- numeric(4)
onRoad <- numeric(4)
point <- numeric(4)

# Loop through all unique years and sum all emissions as with plot1/2
counter <- 0
for(yr in years){
    counter = counter + 1
    nonRoad[counter] <- sum(em1$Emissions[em1$year==yr])
    nonPoint[counter] <- sum(em2$Emissions[em2$year==yr])
    onRoad[counter] <- sum(em3$Emissions[em3$year==yr])
    point[counter] <- sum(em4$Emissions[em4$year==yr])    
}
# Combine all into a single data.frame for ggplot
df <- data.frame(years, nonRoad, nonPoint, onRoad, point)

# And melt them for the same reason
df <- melt(df ,  id = 'years', variable_name = 'series')

# And plot in LOG scale
png(file = 'plot3.png')
p <- ggplot(df, aes(years,log10(value)))
p + geom_line(aes(colour = series)) + 
    labs(title = "Time series of emissions by type") + 
    xlab("Year") + ylab("log(Total Emissions)")
dev.off()
