
library(shiny)
library(tidyverse)
library(ggplot2)
library(DT)

majors <- read_csv("https://raw.githubusercontent.com/wastjohn/COMP112-Final/main/majordata.csv")

ui <- fluidPage(

    titlePanel('Macalester Major Data'),
    
    tabsetPanel(type = "tabs",
                tabPanel("Scatter Plot", 
                         plotOutput("fgen_plot"),
                         selectInput('x_var', label = 'First Gen X Variable', choices = c(names(majors))),
                         selectInput('y_var', label = 'First Gen Y variable', choices = c(names(majors))),
                         plotOutput("plot"),
                         ),
                tabPanel("Classification Tree", 
                         plotOutput("treeplot"),
                         selectInput('filter_opt', label = 'Filter Options', choices = c(names(majors)), multiple = TRUE)
                         
                         )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  output$fgen_plot <- renderPlot({
    
    ggplot(f_gen, aes(x = .data[[input$x_var]]))+
      geom_bar() +
      labs(title = 'First Gen Scatter Plot')
    
  })
  
  output$plot <- renderPlot({
    
    ggplot(majors, aes(x = .data[[input$x_var]]))+
      geom_bar() +
      labs(title = 'Total Major Scatter Plot')
  
  })
  
  output$treeplot <- renderPlot({
    
    first_gen_major <- majors %>% 
      drop_na(first_gen)
    
    shuffle_index <- sample(1:nrow(first_gen_major))
    
    first_gen_major <- first_gen_major[shuffle_index, ]
    
    clean_first_gen <- first_gen_major %>%
      select(c(first_gen, sex, tot_enroll_ct, prefix_count, major1_division))
    
    create_train_test <- function(data, size = 0.8, train = TRUE) {
      n_row = nrow(data)
      total_row = size * n_row
      train_sample <- 1:total_row
      if (train == TRUE) {
        return (data[train_sample, ])
      } else {
        return (data[-train_sample, ])
      }
    }
    
    data_train <- create_train_test(clean_first_gen, 0.8, train = TRUE)
    
    data_test <- create_train_test(clean_first_gen, 0.8, train = FALSE)
    
    fit <- rpart(sex~., data = data_train, method = "class")
    
    rpart.plot(fit, extra = 106)
    
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)
