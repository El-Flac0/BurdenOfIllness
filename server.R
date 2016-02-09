## Server
library(shiny)
require(dplyr)
require(reshape2)
require(RColorBrewer)
require(scales)
require(ggplot2)
source('helper.R')

data <- readRDS("data/premData.rds")

shinyServer(function(input, output) {
  
  output$table1 <- renderTable({
    
    liveBirths <- input$text1
    
    xPreterm <- input$text2
      
    vPreterm <- input$text3
    
    mPreterm <- input$text4
    
    years <- input$slider1
    
    indirect <- input$check1
    
    cost <- switch(input$radio1,
                   "Total Costs" = "total",
                   "Costs per Newborn" = "costPerCase")
    
    totalCostTable(liveBirths=as.numeric(liveBirths),
               xPreterm=as.numeric(xPreterm),
               vPreterm=as.numeric(vPreterm),
               mPreterm=as.numeric(mPreterm),
               start=years[1],
               end=years[2],
               cost=cost,
               indirect=indirect)
    
  }, include.rownames=FALSE)
  
  output$plot1 <- renderPlot({
    
    liveBirths <- input$text1
    
    xPreterm <- input$text2
    
    vPreterm <- input$text3
    
    mPreterm <- input$text4
    
    years <- input$slider1
    
    indirect <- input$check1
    
    cost <- switch(input$radio1,
                   "Total Costs" = "total",
                   "Costs per Newborn" = "costPerCase")
    
    plotMaker(liveBirths=as.numeric(liveBirths), 
              xPreterm=as.numeric(xPreterm),
              vPreterm=as.numeric(vPreterm),
              mPreterm=as.numeric(mPreterm),
              start=years[1],
              end=years[2],
              cost=cost,
              indirect=indirect)
    
  })
  
})