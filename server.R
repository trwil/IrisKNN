library(shiny)
library(class)
library(caret)
library(ggplot2)
library(dplyr)
library(plotly)

shinyServer(function(input, output) {
  totalFrame <- reactive({
    trainingIndices <-createDataPartition(iris$Species, p=input$prop, list=FALSE)
    training.data <- iris[trainingIndices,]
    test.data <- iris[-trainingIndices,]

    predicted <- knn(select(training.data, -Species),
                     select(test.data, -Species),
                     cl=training.data$Species,
                     k = input$k_val,
                     use.all = TRUE)

    training.data$type <- "training"
    test.data$type = ifelse(predicted == test.data$Species, "correct", "incorrect")
    test.data$predictedSpecies <- predicted
    training.data$predictedSpecies <- NA

    rbind(test.data, training.data)
  })
  
  output$petalPlot <- renderPlotly({
    p <- plot_ly(data = totalFrame(), 
             x = ~Petal.Length,
             y = ~Petal.Width,
             color =~Species,
             symbol = ~type,
             symbols = c('circle','x','o'),
             marker = list(size = 10),
             type = "scatter",
             hoverinfo = 'text',
             text = ~paste('</br> Point Type: ', type,
                           '</br> Species: ', Species,
                           '</br> Predicted Species: ', predictedSpecies))
  })

  output$sepalPlot <- renderPlotly({
      p <- plot_ly(data = totalFrame(), 
                   x = ~Sepal.Length,
                   y = ~Sepal.Width,
                   color =~Species,
                   symbol = ~type,
                   symbols = c('circle','x','o'),
                   marker = list(size = 10),
                   type = "scatter",
                   hoverinfo = 'text',
                   text = ~paste('</br> Point Type: ', type,
                                 '</br> Species: ', Species,
                                 '</br> Predicted Species: ', predictedSpecies))})
})

