# ui.R 
# 
# Interface script for PowerFactor shiny dashboard; see wrapper for docs
# 
# Iraklis Konstantopoulos
# Sydney, 05 August 2015
# 

library(shiny)
# Read the data frame to get the list of meters
nm <- names(read.csv('kWh.csv'))

# First step to unique names: kWh column names
meter_names = nm[grep('kWh', nm)]  

# Split on kWh and keep only the meter number
for(i in 1:4){ 
  meter_names[i] = strsplit(meter_names, '_')[[i]][2]
  }

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