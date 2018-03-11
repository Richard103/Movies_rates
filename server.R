#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(stringr)
library(dplyr)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
    # Create a subset of data filtering for selected title types
    movies_subset <- reactive({
        req(input$selected_type) # ensure availablity of value before proceeding
        filter(movies, title_type %in% input$selected_type)
    })
    
    # Update the maximum allowed n_samp for selected type movies
    observe({
        updateNumericInput(session, 
                           inputId = "n_samp",
                           value = min(nrow(movies), nrow(movies_subset())),
                           max = nrow(movies_subset())
        )
    })
    
    # Create new df that is n_samp obs from selected type movies
    movies_sample <- reactive({ 
        req(input$n_samp) # ensure availablity of value before proceeding
        sample_n(movies_subset(), input$n_samp)
    })
    
    # Create scatterplot object the plotOutput function is expecting 
    output$scatterplot <- renderPlot({
        ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y,
                                                  color = input$z)) +
            geom_point(alpha = 0.5, size = input$size) +
            labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
                 y = toTitleCase(str_replace_all(input$y, "_", " ")),
                 color = toTitleCase(str_replace_all(input$z, "_", " ")),
                 title = toTitleCase(input$plot_title))
    })
    
    # Print number of movies plotted 
    output$n <- renderUI({
        types <- movies_sample()$title_type %>% 
            factor(levels = input$selected_type) 
        counts <- table(types)
        
        HTML(paste("There are", counts, input$selected_type, "movies in this dataset. <br>"))
    })
    
    # Print data table if checked
    # output$moviestable <- DT::renderDataTable(
    #     if(input$show_data){
    #         DT::datatable(data = movies_sample()[, 1:7], 
    #                       options = list(pageLength = 10), 
    #                       rownames = FALSE)
    #     }
    # )
    
})
