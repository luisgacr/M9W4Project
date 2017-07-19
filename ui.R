#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate) #<------------------------------------------------------------ library lubridate
library(plotly)
library(dplyr)
library( reshape2)
library(mongolite)
library(lubridate)
library(forecast)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Colombia's offcial exhange rate"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       dateInput("plotStartDate", "Plot start", value = "1991-11-29", min = "1991-11-28", max = "2017-03-28",
                 format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                 language = "en", width = NULL),
       dateInput("plotEndDate", "Plot end", value = "2017-03-28", min = "1991-12-01", max =  "2017-03-28",
                 format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                 language = "en", width = NULL),
       selectInput("differencesModel", "Choose a difference model:",
                   c("Absolut" = "abs", "Logarithmic" = "log")
       ),
       actionButton(inputId="calculate",label="Create plots")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", 
                 tags$b(textOutput(outputId = "warning")),
                 tags$b(textOutput(outputId = "warning2")),
                 tags$b(textOutput(outputId = "separator")),
                 plotlyOutput("distPlot"), 
                 tags$b(textOutput(outputId = "separator2")),
                 tags$b(textOutput(outputId = "separator3")),
                 plotlyOutput("diffPlot")
                 ),
        tabPanel("Rates", fluidRow(
                             column(12,
                                    dataTableOutput('table')))),
        tabPanel("User documentation", 
                 h4("The purpose of the website is:"),
                 h4("- Display the Colombian Peso (COP) exchange rate (vs USD) in table"),      
                 h4("- Plot the exchange rates vs the dates"),
                 h4("- Plot the daily rate differences. This can be done in two ways:"),
                 h4("-- Display the differences of the absolute rates"),
                 h4("-- Display the differences of the logarithms of the rates."),
                 h4(".."),   
                 h4("The user can select:"),
                 h4("- The range in dates of the rates that will be displayed:"),
                 h4("- The type of rate difference that will be displayed (absolute rate or rate logarithm"),
                 h4(".."),
                 h3("Instructions"),
                 h4(".."),   
                 h4("   There are two date fields:"),
                h4("   - The initial plot date (date of the first rate and difference)"),
                 h4(" -- The minimum date allowed for this field is 1991-11-28, and the maximun value is 2017-03-28"),
                 h4("- The final plot data (date of last rate and difference)"),
                 h4("-- The minimum date allowed for this field is 1991-12-01, and the maximun value is 2017-03-28"),
                 h4(".."),
                 h4("There is a selector where the user can select the type of difference to display:"),
                 h4("- Absolute"),
                 h4("- Logarithm"),
                 h4(".."),
                 h4(" In the bottom of the side bar, there is a button <Create plots>. The user must press this button to display the plots in the folowing cases:"),
                 h4(" - When the website is initiated"),
                 h4("- Every time any date is changed"),
                 
                 h4("The differences chart is updated automatically when the user selects a new type of difference."),
                 
                 h4("The plots were built using plotly; therefore all the provided by this type of plot is avialable to the user.")
                 
                 ))
    )
  )
))
#)

#tabsetPanel(
#  tabPanel("Plot", plotOutput("plot")),
#  tabPanel("Summary", verbatimTextOutput("summary")),
#  tabPanel("Table", tableOutput("table"))
#)


#shinyApp(
#  ui = fluidPage(
#    fluidRow(
#      column(12,
#             dataTableOutput('table')
#      )
#    )
#  ),
#  server = function(input, output) {
#    output$table <- renderDataTable(originalSeries)
#  }
#)