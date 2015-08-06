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

shinyServer(function(input, output) {

    # Plot 1: Consumption Time Series
    output$TimeSeries <- renderPlot({

        # Restrict the data frame to the date selected
        plotFrame <- dat[as.Date(dat$Date) == as.Date(input$Date),]

        # Get the index of the column to plot
        myCol <- grep(input$Meter, names(plotFrame))[1]

        # ggplot the data: kWh and PF
        qplot(x=as.list(plotFrame[16])[[1]], 
                     y=as.list(plotFrame[myCol])[[1]],
                     xlab='Time [hh:mm:ss]', ylab='Consumption [kWh]', 
                     main = paste('Meter ', input$Meter), asp=0.5)

        #ggplot() + 
        #  geom_dotplot(aes(y=as.list(plotFrame[myCol])[[1]]))
        
        # Also need to set up the four summary boxes
        
        # I NEED TO REORGANISE THE DF. NO GOOD! 
        
    })
})


