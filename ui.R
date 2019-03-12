library(shiny)
library("dplyr")
library("leaflet")
library("tidyr")
library("ggplot2")
library("ggmap")
#LOAD ALL DATA SETS HERE AT THE BEGINNING
countries <- read.csv("data/countries_long_lat.csv", stringsAsFactors = FALSE)
full_pop_data <- read.csv("data/FAOSTAT_population.csv", stringsAsFactors = FALSE)
full_land_data <- read.csv("data/FAOSTAT_landuse.csv", stringsAsFactors = FALSE)
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv", stringsAsFactors = FALSE)

navbarPage(
  "UN FAO Data Analysis",
  
  tabPanel(
    "Introduction",
    titlePanel("What this analysis looks at"), 
   p("The Food and Agriculture Organization ", strong("FAO"), "is a specialized agency of the United Nations that leads international efforts to defeat hunger."),
    p("This analysis project utilizes datasets which are collected and compiled by the Food and Agriculture Organization of the United Nations. This project specifically
      looks at the datasets of", strong("Annual population, Land Use, Economic Macroindicators, Energy Use, and Food Security,"), "to answer questions about if there is 
      a correlation between these domains."),
   img("", src = "http://www.fao.org/uploads/pics/FAO_logo_Blue_3lines_en_01.jpg", align = "center")
   )
  ,
  
  tabPanel(
    "Choropleth",
    titlePanel(strong("Choropleth of different types of land use")),
    h4("This choropleth shows the change of different types of land over time in every country."),
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
        plotlyOutput("choropleth"),
        p(em("Countries that have changed names, or borders, such as Sudan and South Sudan may have some data missing for 
          the years after they changed."))
      )
    )
  ),
  tabPanel(
    "Macro Indicators"
    
  ),
  tabPanel(
    "Food Security"
    
  ),
  tabPanel(
    "Energy Use"
    
  )
  
  )
