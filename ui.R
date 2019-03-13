library("shiny")
library("dplyr")
library("shinyWidgets")
source("server.R")

energy <- read.csv("data/FAOSTAT_data_3-7-2019.csv",stringsAsFactors = F)
energy[is.na(energy)] <- 0
years <- range(energy$Year)
countries <- unique(energy$Country)
items <- unique(energy$Item)

page_energy <- fluidPage(
  titlePanel("the energy use in agriculture"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "year",
        label = "choose the year range",
        min = years[1],
        max = years[2],
        value = years,
        step = 1
        ),
     pickerInput(
        "country",
        label = "choose the country",
        choices = countries,
        selected = "Afghanistan",
        options = list(`actions-box` = TRUE),
        multiple = T
      ),
      selectInput(
        "element",
        label = "choose the element",
        choices = c(
          "Consumption in Agriculture (in Terajoule)" = "Consumption in Agriculture",
          "Emissions (CH4) (Energy) (in gigagrams)" = "Emissions (CH4) (Energy)",
          "Emissions (CO2eq) from CH4 (Energy) (in gigagrams)" = "Emissions (CO2eq) from CH4 (Energy)",
          "Emissions (N2O) (Energy) (in gigagrams)" = "Emissions (N2O) (Energy)",
          "Emissions (CO2eq) from N2O (Energy) (in gigagrams)" = "Emissions (CO2eq) from N2O (Energy)",
          "Emissions (CO2) (Energy) (in gigagrams)" = "Emissions (CO2) (Energy)",
          "Emissions (CO2eq) (Energy) (in gigagrams)" = "Emissions (CO2eq) (Energy)",
          "Implied emission factor for CH4 (in kg/TJ)" = "Implied emission factor for CH4",
          "Implied emission factor for N2O (in kg/TJ)" = "Implied emission factor for N2O",
          "Implied emission factor for CO2 (in g/kWh)" = "Implied emission factor for CO2"
        ),
        selected = "Consumption in Agriculture",
        
      ),
     selectInput(
       "item",
       label = "choose the item",
       choices = items,
       selected = "Electricity"
       )
     ),
     mainPanel(plotOutput("trend"))
  )
  )
