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

shinyUI(fluidPage(
  titlePanel("Consumed vs Delivered Energy"), 
  
  sidebarLayout(position="right",
    sidebarPanel(
      # Text
      h3("Input panel"),
      helpText("Please select a date and a sub-meter."),
      # Calendar pop-up
      dateInput("Date", "Date:", value='2015-01-01', format='yyyy-mm-dd'),
      # Meter selector drop-down
      selectInput("Meter", "Meter ID:", choices=meter_names),
      helpText("Selecting dates outside the range for which data exist ", 
               "will give rise to a blank canvas. ")
      ),
    mainPanel(
      plotOutput("TimeSeries"),
      #br(),
      h3('Usage Note'),
      p("This dashboard displays electricity consumption (kWh, dots) and load (kVAh, ",
          "stars) for a site with four separate sub-meters. The cadence is 15 minutes. ", 
          "The Power Factor (PF), being the ratio of consumption-to-load is plotted ", 
          "as a solid line in the bottom panel. In the ideal scenario the PF will ",
          "always equal unity, meaning that the site is consuming all the energy ", 
          "is being delivered. Underuse of delivered energy will lead to higher ", 
          "energy rates and infrastructure costs. "),
      p("Using this interface a building manager or site engineer will be able to ", 
        "scout for performance and energy efficiency, and manage energy and ", 
        "facility costs. "),
      p("All data shown in this demonstration are simulated. ")
      
    )
    )
))