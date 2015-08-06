# ui.R 
# 
# Interface script for PowerFactor shiny dashboard; see wrapper for docs
# 
# Iraklis Konstantopoulos
# Sydney, 05 August 2015
# 

library(shiny)
# Read the data frame to get the list of meters
meter_names <- names(read.csv('kWh.csv'))[2:5]

# Remove the leading 'X' added by read.csv
#meter_names <- substring(meter_names, 2)

shinyUI(pageWithSidebar(
  headerPanel("Consumed vs Delivered Energy"), 
  sidebarPanel(

    dateInput("Date", "Date:", 
              value='2015-01-01', format='yyyy-mm-dd'),
    
    selectInput("Meter", "Meter:", choices=meter_names)
  ),
  mainPanel(
    plotOutput("TimeSeries"),
    plotOutput("Geomapper")
  )
))