#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(DT)

majors <- read_csv("https://raw.githubusercontent.com/wastjohn/COMP112-Final/main/majordata.csv")

ui <- fluidPage(

    titlePanel('Macalester Major Data'),
    
    tabsetPanel(type = "tabs",
                tabPanel("Scatter Plot", 
                         plotOutput("plot"),
                         selectInput('x_var', label = 'X Variable', choices = c(names(majors))),
                         selectInput('y_var', label = 'Y variable', choices = c(names(majors)))
                         ),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Table", tableOutput("table")),
                tabPanel("Scatter Plot", plotOutput("plot")),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Table", tableOutput("table"))
    )

    #dataTableOutput('table'),

    #fluidRow(
     # column(4,
      #       selectInput('filter_var', label = 'Filter by:', choices = c(names(majors))),
       #      selectInput('operation', label = 'Operation', choices = c('>', '<', '==', '>=', '<=')),
        #     numericInput('filter_val', label = 'Value', value = 1)),
             #actionButton('add_filter_btn', 'Add Filter')
      #),
      #column(4, offset = 1,
             #selectInput('group_var', label = 'Group by:', choices = c(names(majors))),
             #actionButton('add_filter_btn', 'Add Filter')
      #),
    
    #plotOutput('plot')
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
}


# Run the application 
shinyApp(ui = ui, server = server)
