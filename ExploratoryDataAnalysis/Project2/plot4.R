# Coursera/JHU Data Science Track: Exploratory Data Analysis
# 
# Course Project 2
# 
# Iraklis Konstantopoulos, 
# Sydney, 26 April 2015

# Question 4
# ----------
# Across the United States, how have emissions from coal combustion-
# related sources changed from 1999–2008?

library(dplyr)

pm25 <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

years <- summarise(group_by(pm25, year))$year

# Scan SSC$EI.Sector for mentions of coal, get index of SSCs, subset
coal <- SCC$SCC[grep('Coal|coal|COAL', SCC$EI.Sector)]
df <- filter(pm25, SCC %in% coal)

# Get the average by year
coalEmissions = numeric(4)
counter <- 0
for(yr in years){
    counter = counter + 1
    coalEmissions[counter] <- sum(df$Emissions[df$year==yr])
}

# Combine all into a single data.frame for ggplot and melt
df <- data.frame(years, coalEmissions)
df <- melt(df ,  id = 'years', variable_name = 'coal')

# I'd like to plot all the sources of coal in a single canvas
png(file = 'plot4.png')
p <- ggplot(df, aes(years,log10(value)))
p + geom_line(aes(colour = coal)) + 
    labs(title = "Time series of coal-related emissions") + 
    xlab("Year") + ylab("log(Total Emissions)")
dev.off()
