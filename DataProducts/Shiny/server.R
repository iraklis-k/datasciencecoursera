# server.R
# 
# Programme script for PowerFactor shiny dashboard; see wrapper for docs
# 
# Iraklis Konstantopoulos
# Sydney, 05 August 2015
# 

library(shiny, grid)
library(scales)

# Input consumption data
kWh <- read.csv('kWh.csv')
kVAh <- read.csv('kVAh.csv')

# Remove the leading 'X' added by read.csv
#names(kWh)[2:5] <- substring(names(kWh)[2:5], 2)
#names(kVAh)[2:5] <- substring(names(kVAh)[2:5], 2)

shinyServer(function(input, output) {

    # Plot 1: Consumption Time Series
    output$TimeSeries <- renderPlot({

        # Restrict the data frame to the date selected
        plotkWh <- kWh[as.Date(kWh$Date) == as.Date(input$Date),]
        plotkVAh <- kVAh[as.Date(kVAh$Date) == as.Date(input$Date),]
        
        # Get the index of the column to plot
        myCol <- grep(input$Meter, names(plotkWh))[1]
        
        # And further prune the data frame to only include plot data
        plotFrame <- data.frame(plotkWh[myCol], plotkVAh[myCol], 
                  as.POSIXct(plotkWh$Date_Time, tz="UTC", 
                             format="%Y-%m-%d %H:%M:%S"))
        names(plotFrame) <- c("kWh", "kVAh", "Time")
        timeTicks <- substring(as.character(plotFrame$Time), 
                               12, 16)[seq(1, length(timeTicks), 8)]
        print(timeTicks)
        # ggplot the data: kWh and kVAh (scatter), and PF (line)
        #qplot(Time, kWh, data=plotFrame)
        ggplot(plotFrame, aes(Time)) +
          geom_point(size=3, alpha=0.5, colour="blue", aes(y=kWh)) +
          geom_point(size=10, shape="*", colour="darkgrey", aes(y=kVAh)) +
          #geom_line(aes(y=kWh/kVAh)) +
          theme(axis.text.x=element_text(angle=30)) + 
          scale_x_datetime(breaks = "2 hour", labels=date_format("%H:%M"))

        # Also need to set up the four summary boxes

  })
})


