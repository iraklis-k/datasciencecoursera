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
    # Text
    h3("Input panel"),
    p("Please select a date and a sub-meter below."),
    # Calendar pop-up
    dateInput("Date", "Date:", value='2015-01-01', format='yyyy-mm-dd'),
    # Meter selector drop-down
    selectInput("Meter", "Meter ID:", choices=meter_names),
    # Explanatory text
    helpText("This dashboard displays simulated electricity consumption (dots, kWh) ",
             "and load (stars, kVAh) for a site with four separate sub-meters. ", 
             "The Power Factor, being the ratio of consumption-to-load is plotted ", 
             "as a solid line in the bottom panel. ")
  ),
  mainPanel(
    plotOutput("TimeSeries")
  )
))