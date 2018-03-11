#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
    
    # Sidebar layout with a input and output definitions
    sidebarLayout(
        
        # Inputs
        sidebarPanel(
            
            h3("Input parametrs"),      
            
            # Select variable for y-axis 
            selectInput(inputId = "y", 
                        label = "Y-axis:",
                        choices = c("IMDB rating" = "imdb_rating", 
                                    "IMDB number of votes" = "imdb_num_votes", 
                                    "Critics Score" = "critics_score", 
                                    "Audience Score" = "audience_score", 
                                    "Runtime" = "runtime"), 
                        selected = "audience_score"),
            
            # Select variable for x-axis 
            selectInput(inputId = "x", 
                        label = "X-axis:",
                        choices = c("IMDB rating" = "imdb_rating", 
                                    "IMDB number of votes" = "imdb_num_votes", 
                                    "Critics Score" = "critics_score", 
                                    "Audience Score" = "audience_score", 
                                    "Runtime" = "runtime"), 
                        selected = "critics_score"),
            
            # Select variable for color
            selectInput(inputId = "z", 
                        label = "Color by:",
                        choices = c("Title Type" = "title_type", 
                                    "Genre" = "genre", 
                                    "MPAA Rating" = "mpaa_rating", 
                                    "Critics Rating" = "critics_rating", 
                                    "Audience Rating" = "audience_rating"),
                        selected = "mpaa_rating"),
            
            hr(),      # Horizontal line for visual separation
            
            # Set alpha level
            # sliderInput(inputId = "alpha", 
            #             label = "Alpha:", 
            #             min = 0, max = 1, 
            #             value = 0.5),
            
            # Set point size
            sliderInput(inputId = "size", 
                        label = "Size of points:", 
                        min = 0, max = 5, 
                        value = 2),
            
            # Enter text for plot title
            textInput(inputId = "plot_title", 
                      label = "Plot title", 
                      placeholder = "Enter text to be used as plot title"),
            
            hr(),      # Horizontal line for visual separation
            
            h3("Sampling and subsetting"),      
            
            # Select which types of movies to plot
            checkboxGroupInput(inputId = "selected_type",
                               label = "Select movie type(s):",
                               choices = c("Documentary", "Feature Film", "TV Movie"),
                               selected = "Feature Film"),
            
            # Select sample size
            numericInput(inputId = "n_samp", 
                         label = "Sample size:", 
                         min = 1, max = nrow(movies), 
                         value = nrow(movies)),
            
            hr()      # Horizontal line for visual separation
            
            # Show data table
            # checkboxInput(inputId = "show_data",
            #               label = "Show data table",
            #               value = TRUE)
            
        ),
        
        # Output:
        mainPanel(
            
            # Show scatterplot
            h3("Output scatterplot"),          # Third level header: Scatterplot
            plotOutput(outputId = "scatterplot"),
            br(),          # Single line break for a little bit of visual separation
            
            # Print number of obs plotted
            h4(uiOutput(outputId = "n")),    # Fourth level header
            br(), br()          # Two line breaks for a little bit of visual separation
            
            # Show data table
            # h3("Data table"),   
            # DT::dataTableOutput(outputId = "moviestable")
        )
    )
))