#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(lubridate) #<------------------------------------------------------------ library lubridate
library(dplyr)
library( reshape2)
library(mongolite)
library(lubridate)
library(forecast)


#originalSeries<-read.table(file="D:/ApplicationFiles/Aprendizaje/Shiny/EjemploTabla/Archivo prueba shiny.txt", 
#                           header=TRUE, sep="\t",row.names = NULL)
#head(originalSeries)

#///
#Devuelve data frame c("Date","Rate"), convertido a fechas y números, tasas diarias.
DF.DailyCleanTRM=function(originalSeries)
{
  cleanSeries<-originalSeries[,c(1,2)]
  
  names(cleanSeries)<-c("date","rate")
  
  dates<-dmy(cleanSeries$date)
  cleanSeries[,1]<-dates
  
  rates<-as.numeric(gsub(",","",sub("\\$ ","",as.character(cleanSeries$rate))))#<------------------------------------------------------sub: elimina el primer "head(tt)
  cleanSeries[,2]<-rates
  
  cleanSeries <- dplyr::filter( cleanSeries, !is.na(cleanSeries$date) | !is.na(cleanSeries$rate))
  
  cleanSeries
}

DF.ModelDates=function(plotStartDate,plotEndDate){
  
  plotStartDate<-max(plotStartDate,ymd("1991-11-28"))
  plotEndDate<-min(max(plotEndDate,plotStartDate),ymd("2017-3-28"))
  c(plotStartDate,plotEndDate)
}

DF.FilterDates=function(dailySeries,plotStartDate,plotEndDate){
  as.data.frame(dplyr::filter( dailySeries, date>=plotStartDate & date<=plotEndDate))
  }

DF.Plotly=function(dailySeries,plotStartDate,plotEndDate){
  selectedSeries<-DF.FilterDates(dailySeries,plotStartDate,plotEndDate)
  graphTitle<-"Colombian Pesos (COP) per 1 USD"
  p<-plot_ly(selectedSeries, x = ~date, y = ~rate ,type="scatter", mode="lines")
  #p<-p %>% layout(title = "Colombian Pesos (COP) per 1 USD")
  p<-p %>% layout(title = graphTitle)
  p
}

DF.Differences=function(dailySeries){
  lengthExperience<-dim(dailySeries)[1]
  lagTRM=dailySeries$rate[-lengthExperience]#;lagTRM
  periodTRM=dailySeries$rate[-1]#;periodTRM
  diffDates<-dailySeries$date[-1]
  
  differencesSeries<-data.frame(diffDates, periodTRM-lagTRM)
  names(differencesSeries)<-c("date","difference")
  differencesSeries
}


options(mongodb = list(
  "host" = "ds137882.mlab.com:37882",
  "username" = "luisgacr",
  "password" = "finac123"
))

databaseName <- "finacpredict"

urlml = sprintf(
  "mongodb://%s:%s@%s/%s",
  options()$mongodb$username,
  options()$mongodb$password,
  options()$mongodb$host,
  databaseName)

dayName<-"Wednesday"


TRMs <- mongo( collection = "TRMs", url = urlml)
tRMs<-TRMs$find()
#head(tRMs)
dailySeries<-DF.DailyCleanTRM( tRMs )

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  modelDates<-eventReactive(input$calculate, DF.ModelDates(input$plotStartDate,
                                                        input$plotEndDate))
  
  #selectedSeries<-reactive({DF.FilterDates(ModelDates(1),ModelDates(2))})
  
  
  output$distPlot <- renderPlotly({
    
    DF.Plotly(dailySeries,modelDates()[1],modelDates()[2])
    #plot_ly(selectedSeries, x = ~date, y = ~rate ,type="scatter", mode="lines")
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2] 
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  output$diffPlot <- renderPlotly({
    
    filteredSeries<-DF.FilterDates(dailySeries,modelDates()[1],modelDates()[2])
    #graphTitle<-"Differencea in absolute rate"
    if(input$differencesModel == "log"){
      filteredSeries$rate<-log(filteredSeries$rate)
      filteredSeries<-filteredSeries[-1,]
      graphTitle<-"Differences in rate logarithm"
    }
    else
    {
      graphTitle<-"Differences in absolute rate"
    }
    
    
    differencesSeries<-DF.Differences(filteredSeries)
    p<-plot_ly(differencesSeries, x = ~date, y = ~difference ,type="scatter", mode="lines")
    p<-p %>% layout(title = graphTitle)
    p
    
  })
  output$table <- renderDataTable(dailySeries)
  output$warning<-renderText("NOTE: To display plot, and after changing dates, it is necessary to press <Create Plot>!")
  output$warning2<-renderText("Please review User Documentation Tab")
  output$separator<-renderText("...")
  output$separator2<-renderText("...")
  output$separator3<-renderText("...")
  
  
})

#?plot_ly
