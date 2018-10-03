
# THIS IS THE UI FOR THE INTBOI

library(shiny)

shinyUI(fluidPage(
  
  titlePanel('Burden of Illness Model'),
  
  # Sidebar with a slider input for years
  wellPanel(
    tags$style(type="text/css", '#leftPanel { width:270px; float:left;}'),
    id = "leftPanel",
    
    textInput("text1", label = h5("Live Births"), 
              value = "790000"),
    p("Incidence of preterm birth"),
    textInput("text2", label = h6("Less than 28 weeks"), 
              value = "0.0048"),
    textInput("text3", label = h6("28-32 weeks"), 
              value = "0.0123"),
    textInput("text4", label = h6("33-36 weeks"), 
              value = "0.0546"),
    sliderInput("slider1", label = h5("Year Since Birth"),
                min = 1, max = 10, value = c(1,10), step = 1),
    radioButtons("radio1", label = h5("Resource Use Breakdown"),
                 choices = list("Total Costs", "Costs per Newborn"),
                 selected = "Total Costs"),
    checkboxInput("check1", label = "Include Indirect Costs", TRUE)
  ),
  
  # Show a table of market shares, and plot of costs
  mainPanel(
    tabsetPanel(
      tabPanel('Main',
               br(),
               p('Welcome to the interactive webapp exploring the burden of illness for premature births, 
                 based on incidence, resource use, and costs from the United Kingdom. All costs in 2015 GBP'),
               p('Utilise the input sidebar to enter the parameters of the model. Then select
                 the appropriate plotting options to present the corresponding results.
                 Detailed burden of ilnness costs can be seen on the Total Costs tab, with all
                 other data, such as unit costs and quantities for medical resource use, hardcoded into the model.'),
               br(), 
               plotOutput('plot1')
               ),
      tabPanel('Total Cost Values',
               br(),
               p('The Total Costs table will update as parameters are altered in the sidebar.
                 Adjusting the year range will alter the constituent parts of the table, and
                 associated calculations for the BOI Model.'),
               br(),   
               tableOutput('table1')
               )
      )   
      ) 
      )
      )