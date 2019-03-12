library(shiny)
library(dplyr)
library(ggplot2)
data("gdp_d")


server <- function(input, output) {
  output$gdp_plot <- renderPlot({
     gdp_plot <-  ggplot(data = gdp_d) +
      geom_line(mapping = aes(
        x = Year,
        y = Value,
        color = Value
      )) +
      labs(
        x = "Year", 
        y = "GDP",
        title = "GDP and country"
      )
  })
  
}
