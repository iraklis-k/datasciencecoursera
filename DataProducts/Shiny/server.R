# server.R
# 
# Programme script for PowerFactor shiny dashboard; see wrapper for docs
# 
# Iraklis Konstantopoulos
# Sydney, 05 August 2015
# 

library(shiny, gridExtra)

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
        plotFrame <- data.frame(plotkWh[myCol], plotkVAh[myCol], plotkWh[6])
        names(plotFrame) <- c("kWh", "kVAh", "Time")
        
        # ggplot the data: kWh and kVAh (scatter), and PF (line)
        #qplot(Time, kWh, data=plotFrame)
        ggplot(plotFrame, aes(Time)) +
          geom_point(aes(y=kWh)) +
          geom_point(aes(y=kVAh)) #+
          #geom_line(aes(y=kWh/kVAh))        
                
        # Also need to set up the four summary boxes

    })
})


