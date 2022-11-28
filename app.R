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

majors <- read_csv("https://raw.githubusercontent.com/wastjohn/COMP112-Final/main/majordata.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel('Macalester Major Data'),

    tableOutput('table'),
    # Sidebar with a slider input for number of bins 
    fluidRow(
      column(3,
             selectInput('variable', label = 'Filter by:', choices = c(names(majors))),
             actionButton('add_filter_btn', 'Add Filter')
      ),
      column(4, offset = 1,
             selectInput('variable', label = 'Filter by:', choices = c(names(majors))),
             actionButton('add_filter_btn', 'Add Filter')
      ),
      column(5,
             plotOutput('plot')
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$plot <- renderPlot({
    ggplot(majors, aes(x = sex)) +
      geom_bar()
  })
  
  output$table <- renderTable({
    head(majors)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
