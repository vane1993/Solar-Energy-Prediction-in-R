library(shiny)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("AMS 2013-2014 Dataset"),
  
  # Show a plot of the generated distribution
  sidebarPanel(
    selectInput("dataset", "Choose a dataset:", 
                choices = c("Solar Dataset", "Only Stations", "Only Principal Components")), 
    br(),
    selectInput("column", label = h3("Column For Scatter Plot"),
                choices = c("", colnames(new_data)),
                selected = 1,
                width='50%',
                multiple = FALSE),
    br(),
    selectInput("col", label = h3("Column For Histogram"),
                choices = c("", colnames(new_data)),
                selected = 1,
                width='50%',
                multiple = FALSE),
    br(),
    numericInput("obs", "Number of observations to view:", 10),
    br(),
    sliderInput("bins","Number of bins:", min = 5, max = 25, value = 15),
    br(),
    radioButtons("color", "Select color of Plot", 
                 choices = c("Red" ,"Blue" ,"Yellow"), selected = "Blue"),
    br(),
    sliderInput("filter", label = h3("Rows Selected"), min = 1, 
                max = nrow(new_data), value = c(1, 10),
                round = -2, step = 1),
    br(),
    selectInput("columns", label = h3("Select Multiple columns from DT"),
                choices = c("", colnames(new_data)),
                selected = 1,
                width='55%',
                multiple = TRUE)
  ),
  
  mainPanel(
    tabsetPanel(type="tab",
                tabPanel("Scatter Plot", plotOutput("solardataPlot")),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Data" , tableOutput("view")),
                tabPanel("Histogram", plotOutput("hist")),
                tabPanel("DT", column(12, DT::dataTableOutput('scaled_datatable'))
                )   )
  )
)
)
