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

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel('Macalester Major Data'),

    dataTableOutput('table'),
    # Sidebar with a slider input for number of bins 
    fluidRow(
      column(3,
             selectInput('filter_var', label = 'Filter by:', choices = c(names(majors))),
             selectInput('operation', label = 'Operation', choices = c('>', '<', '==', '>=', '<=')),
             numericInput('filter_val', label = 'Value', value = 1),
             #actionButton('add_filter_btn', 'Add Filter')
      ),
      #column(4, offset = 1,
             #selectInput('group_var', label = 'Group by:', choices = c(names(majors))),
             #actionButton('add_filter_btn', 'Add Filter')
      #),
      column(5,
             plotOutput('plot')
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  num_vars <- c()
  
  data <- reactive(majors %>% filter(eval(parse(text=paste0(input$filter_var,input$operation,input$filter_val)))))
  
  output$plot <- renderPlot({
    data() %>%
      ggplot( aes_string(x = input$filter_var)) +
        geom_histogram()
  })
  
  output$table <- renderDataTable({
    datatable(
      data() %>% as.data.frame(),
      options = list(
        scrollX = TRUE,
        scrollY = '250px'
      )        
    )
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
