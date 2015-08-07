# server.R
# 
# Programme script for PowerFactor shiny dashboard; see wrapper for docs
# 
# Iraklis Konstantopoulos
# Sydney, 05 August 2015
# 

library(shiny)
library(ggplot2)
library(gridExtra)
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

        # Decimal places in y tick label
        fmt <- function(){
          #function(x) format(x,nsmall = 2,scientific = FALSE)
          function(x) round(x, digits=2)
        }
        
        # Plot kWh and kVAh (scatter), and PF (line)
        g1 <- ggplot(plotFrame, aes(Time)) +
          #coord_fixed(ratio=1000) + 
          #geom_point(aes(y=kWh, colour="kWh")) +
          #geom_point(aes(y=kVAh, colour="kVAh")) +
          geom_point(size=3, colour='blue', alpha=0.5, aes(y=kWh, colour="kWh")) +
          geom_point(size=10, colour='grey30', shape='*', aes(y=kVAh, colour="kVAh")) +
          ylab("Consumption [kWh, kVAh]") + 
          theme(axis.text.x = element_blank()) + 
          theme(axis.title.x = element_blank()) + 
          theme(plot.margin = unit(c(0., 0., 0., 0.34), "cm")) +
          # --- NOTE: should also cater for three digit kWh values
          #scale_colour_manual("", breaks = c("kWh", "kVAh"),
          #                        values = c("blue", "darkgrey")) +
          #scale_shape_manual("", breaks = c("kWh", "kVAh"),
          #                       values = c(0, "*")) +
          #scale_size_manual("", breaks = c("kWh", "kVAh"),
          #                      values = c(50, 500)) +
          scale_x_datetime(breaks = "2 hour")
          #theme(legend.position=c(.5, .5))
        
        g2 <- ggplot(plotFrame, aes(Time)) + 
          geom_line(aes(y=(kWh/kVAh)), size=1, colour='#9b57a2') + 
          #coord_fixed(ratio=350000) + 
          ylab("Power Factor") + 
          #ylim(c(0.9*min(kWh/kVAh), 1.)) + 
          theme(axis.text.x=element_text(angle=30, hjust=1)) + 
          theme(plot.margin = unit(c(0., 0., 0., 0.), "cm")) +
          scale_x_datetime(breaks = "2 hour", labels=date_format("%H:%M")) + 
          scale_y_continuous(labels=fmt())
          
        grid.arrange(g1, g2)#, 
                     #widths = unit(c(20,20), "cm"),
                     #heights = unit(rep(10, 2), "cm"))
        # Also need to set up the four summary boxes

  })
})


