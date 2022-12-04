
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
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
}


# Run the application 
shinyApp(ui = ui, server = server)
