library("shiny")
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
energy <- read.csv("data/FAOSTAT_data_3-12-2019.csv",stringsAsFactors = F)
energy[is.na(energy)] <- 0
years <- range(energy$Year)
countries <- unique(energy$Country)
items <- unique(energy$Item)

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
    titlePanel(strong("Choropleth of different types of Agricultural land use")),
    h4("This choropleth shows the change of different types of land over time in every country."),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "yearn",
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
          "itemn",
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
    "Energy Use",
    titlePanel("Energy Use and Emissions in Agriculture"),
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
        selectInput(
          "country",
          label = "choose the country",
          choices = countries,
          selected = "Afghanistan",
          #options = list(`actions-box` = TRUE),
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
          selected = "Consumption in Agriculture"
          ),
        selectInput(
          "item",
          label = "choose the item",
          choices = items,
          selected = "Electricity"
        )
      ),
      mainPanel(plotOutput("trend"))
    )))
  
