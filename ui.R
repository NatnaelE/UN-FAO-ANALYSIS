library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)


ui <- navbarPage(
  "GDP and Country",
  tabPanel(
    "Page 1",
    titlePanel("Plot of GDP over the years 2000-2012"),
    sidebarLayout(
      sidebarPanel(
        selectInput("Area", "Country:",
                    input$Area
        ),
        hr(),
        helpText("Data from the UN Food and Agriculture")
      ),
      mainPanel(
        plotOutput("gdp_plot")
      )
    )
  )
)