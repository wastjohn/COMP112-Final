
library(shiny)
library(tidyverse)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(DT)

majors <- read_csv("https://raw.githubusercontent.com/wastjohn/COMP112-Final/main/majordata.csv")

f_gen <- majors %>%
  filter(first_gen == 'first gen')

first_gen_major <- majors %>% 
  drop_na(first_gen) %>%
  select(!starts_with('maj_')) %>%
  select(-c("StudentID", "grad_year"))

ui <- fluidPage(
    #theme = bslib::bs_theme(bootswatch = "darkly"),

    titlePanel('Macalester Major Data'),
    
    tabsetPanel(type = "tabs",
                tabPanel("Bar Plot",
                         fluidRow(
                           column(6, plotOutput("fgen_bar_plot")),
                           column(6, plotOutput("bar_plot"))
                           ),
                         
                         fluidRow(
                           column(12,
                                  selectInput('x_var', label = 'X Variable', choices = c(names(majors))))
                           ), align = 'center'
                         
                         ),
                tabPanel("Classification Tree", 
                         plotOutput("treeplot"),
                         selectInput('filter_opt', label = 'Filter Options', choices = c(names(first_gen_major)), multiple = TRUE, selected = c("first_gen"))
                         
                         ),
                tabPanel("Scatter Plot", 
                         fluidRow(
                           column(6, plotOutput("fgen_scatter_plot")),
                           column(6, plotOutput("scatter_plot"))
                         ),
                         
                         fluidRow(
                           column(12,
                                  selectInput('x_scatter_var', label = 'X Variable', choices = c(names(majors))),
                                  selectInput('y_scatter_var', label = 'Y Variable', choices = c(names(majors)))
                                  )
                         ), align = 'center'
                         
                ),
                tabPanel("Proportional Bar Plot",
                         fluidRow(
                           column(12, plotOutput("prop_bar_plot"))
                         ),
                         
                         fluidRow(
                           column(12,
                                  selectInput('prop_x_var', label = 'X Variable', choices = c(names(majors)), selected = 'first_gen'),
                                  selectInput('division_var', label = 'Division', choices = c(), selected = 'first_gen'),
                                  selectInput('filter_var', label = 'Filter By:', choices = c('Fine Arts', 'Humanities', 'Interdisciplinary', 'Natural Sciences and Mathematics','Social Sciences'), selected = 'Fine Arts')
                           )
                         ), align = 'center'
                         
                ),
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  output$prop_bar_plot <- renderPlot({
    
    ggplot(fgen %>% filter(major1_division == input$filter_var), aes(x = .data[[input$prop_x_var]], fill = major1)) +
      geom_bar(position = 'Fill') +
      labs(title = 'First Gen Prop Bar Plot') +
      scale_fill_viridis_d()
  })
  
  output$fgen_bar_plot <- renderPlot({
    
    ggplot(f_gen, aes(x = .data[[input$x_var]]))+
      geom_bar() +
      labs(title = 'First Gen Bar Plot')
    
  })
  
  output$bar_plot <- renderPlot({
    
    ggplot(majors, aes(x = .data[[input$x_var]]))+
      geom_bar() +
      labs(title = 'Total Major Bar Plot')
  
  })
  
  output$fgen_scatter_plot <- renderPlot({
    
    ggplot(f_gen, aes(x = .data[[input$x_scatter_var]], y = .data[[input$y_scatter_var]]))+
      geom_point() +
      labs(title = 'First Gen Scatter Plot')
    
  })
  
  output$scatter_plot <- renderPlot({
    
    ggplot(majors, aes(x = .data[[input$x_scatter_var]], y = .data[[input$y_scatter_var]]))+
      geom_point() +
      labs(title = 'Total Major Scatter Plot')
    
  })
  
  output$treeplot <- renderPlot({
    
    shuffle_index <- sample(1:nrow(first_gen_major))
    
    first_gen_major <- first_gen_major[shuffle_index, ]

    clean_first_gen <- first_gen_major[c("first_gen", input$filter_opt)]
    
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
    
    fit <- rpart(first_gen~., data = clean_first_gen, method = "class")
    
    rpart.plot(fit, extra = 106)
    
    # predict_unseen <- predict(fit, data_test, type = "class")
    # 
    # table_mat <- table(data_test$first_gen, predict_unseen)
    # 
    # accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)
