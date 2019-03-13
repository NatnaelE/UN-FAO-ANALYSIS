library("dplyr")
library("tidyr")
library("ggplot2")

energy <- read.csv("data/FAOSTAT_data_3-7-2019.csv",stringsAsFactors = F)
energy[is.na(energy)] <- 0
energy <- energy %>%
  filter(Unit != "million kWh")
  

server <- function(input,output){
  
  filtered <- reactive({
    data <- energy %>%
      filter(Year >= input$year[1], Year <= input$year[2])%>%
      filter(Element == input$element)%>%
      filter(Country %in% input$country)%>%
      filter(Item == input$item)
    data 
  })
  
  filtered_one <- reactive({
    data_a <- filtered()%>%
      group_by(Year)%>%
      summarise(Value = sum(Value), Unit = unique(Unit))
    data_a
  })
  
  output$trend <- renderPlot({
    p <- ggplot(data = filtered_one(), mapping = aes_string( x = "Year", y = "Value")) +
      geom_point()+
      geom_line()+
      scale_x_continuous(breaks = c(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012))
   p
  })
}





