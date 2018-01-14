library(shiny)
library(plotly)
library(markdown)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Iris KNN Exploration"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("k_val",
                   "Value of k:",
                   min = 1,
                   max = 5,
                   value = 3),
       sliderInput("prop",
                   "Proportion of training data:",
                   min = 0.1,
                   max = 1.0,
                   step = 0.1,
                   value = 0.7)
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Plots", plotlyOutput("petalPlot"),
                           plotlyOutput("sepalPlot")),
                  tabPanel("Description", 
                           includeMarkdown("about.md")               
                           )
      )
    )
  )
))
