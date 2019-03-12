library(shiny)
library("dplyr")
library("leaflet")
library("tidyr")
library("ggplot2")
library("ggmap")
countries <- read.csv("data/countries_long_lat.csv", stringsAsFactors = FALSE)
full_pop_data <- read.csv("data/FAOSTAT_population.csv", stringsAsFactors = FALSE)
full_land_data <- read.csv("data/FAOSTAT_landuse.csv", stringsAsFactors = FALSE)
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv", stringsAsFactors = FALSE)

navbarPage(
  "Map of Land use",
  
  tabPanel(
    "Choropleth",
    titlePanel("Choropleth of different types of land use"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "year",
          label = "Choose Year",
          choices = c(
            "2000", "2001", "2002", "2003", 
            "2004", "2005", "2006", "2007", 
            "2008", "2009", "2010","2011", 
            "2012", "2013", "2014", "2015",
            "2016"
          )
        ),
        selectInput(
          "item",
          label = "Choose Land type",
          choices = c(
            "Arable land", "Land under permanent crops", "Cropland", 
            "Land under perm. meadows and pastures",
            "Land area equipped for irrigation"
          )
        )
      ),
      mainPanel(
        plotlyOutput("choropleth")
      )
    )
  ))
