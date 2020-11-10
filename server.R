#Library and Data
library(shiny)
library(datasets)


df <- as.data.frame(data)
stations <- df[1:5113,2:99]
stations
pcs <- df[,100:456]
pcs
#Data with no missing values without date
new_data <- df[1:5113,2:456]

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  datasetInput <- reactive({
    switch(input$dataset,
           "Solar Dataset" = new_data,
           "Only Stations" = stations,
           "Only Principal Components" = pcs
    )
  })
  
  column_input <- reactive({
    if (input$column != ""){
      plot(new_data[, input$column], col = input$color, main = "Scatter Plot of Selected Column")
    }
  })
  
  
  col_input <- reactive({
    if (input$col != "")
      x <- new_data[,input$col]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(new_data[, input$col], breaks = bins, col = input$color, xlab = "Selected Column", 
         main = "Histogram of Selected Column",
         sub = "AMS 2013-2014 Solar Dataset")
  })
  
  compute_data <- reactive({
    if ((length(input$columns) > 0)){
      dat <- data.table(datasetInput()[input$filter[1]:input$filter[2], input$columns]);
    } else {
      dat <- data.table();
    }
    return(dat)
  });
  
  output$scaled_datatable = DT::renderDataTable(
    compute_data(), filter = 'top', rownames=FALSE)
  
  #Display a scatter plot for specific olumn
  output$hist <- renderPlot({
    col_input()
  })
  
  #Display a scatter plot for specific olumn
  output$solardataPlot <- renderPlot({
    column_input();
    
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  #Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
})
