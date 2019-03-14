library("shiny")
library("dplyr")
library("leaflet")
library("tidyr")
library("ggplot2")
library("ggmap")
library("plotly")
source("server.R")

# LOAD ALL DATA SETS HERE AT THE BEGINNING
countries <- read.csv("data/countries_long_lat.csv", stringsAsFactors = FALSE)
full_pop_data <- read.csv("data/FAOSTAT_population.csv",
  stringsAsFactors = FALSE
)
full_land_data <- read.csv("data/FAOSTAT_landuse.csv",
  stringsAsFactors = FALSE
)
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv",
  stringsAsFactors = FALSE
)
energy <- read.csv("data/FAOSTAT_data_3-12-2019.csv", stringsAsFactors = F)
energy[is.na(energy)] <- 0
years <- range(energy$Year)
countries <- unique(energy$Country)
items <- unique(energy$Item)

navbarPage(
  "UN FAO Data Analysis",
  tabPanel(
    "Introduction",
    titlePanel("What this analysis looks at"),
    p("The Food and Agriculture Organization ", strong("FAO"), "is a specialized
agency of the United Nations that leads international efforts to defeat hunger
     ."),
    p("This analysis project utilizes datasets which are collected and compiled
by the Food and Agriculture Organization of the United Nations. This project
specifically looks at the datasets of", strong("Annual population, Land Use,
Economic Macroindicators, Energy Use, and Food Security,"), "to answer questions
about if there is a correlation between these domains."),
    img("", src = "http://ba.one.un.org/content/dam/unct/bih/agencies/FAO%20logo.png", align = "center")
  ),

  tabPanel(
    "Choropleth",
    titlePanel(strong("Choropleth of different types of
                      Agricultural land use")),
    h4("This choropleth shows the percentage change of different types of
       Agricultural land over time in every country."),
    h1(),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "yearn",
          label = "Choose Year",
          choices = c(
            "2000", "2001", "2002", "2003",
            "2004", "2005", "2006", "2007",
            "2008", "2009", "2010", "2011",
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
        ),
        p(strong("Arable Land -"), "Land capable of being ploughed and used to grow crops"),
        p(strong("Land Under Permanent Crops -"), "Land that is occupied that crops
                 for long periods, and doesn't need to be replanted after harvests."),
        p(strong("Cropland -")," Areas of land used for the production of adapted
                 crops for harvest."),
        p(strong("Land Under Permanent Meadows and Pastures -")," Land used
                 permanently (five years or more) to grow herbaceous forage crops."),
        p(strong("Land Area Equipped for Irrigation -")," Area equipped to provide
                 water (via irrigation) to the crops, in all area types.")
      ),
      mainPanel(
        plotlyOutput("choropleth"),
        p(em("Countries that have changed names, or borders, such as Sudan and
        South Sudan may have some data missing for
          the years after they changed."))
      )
    )
  ),
  tabPanel(
    "Macro Indicators",
    titlePanel("Barplot of Economic Distribution of Wealth in Countries"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "country_y",
          label = "Choose country",
          choices = c(
            "Afghanistan", "Albania", "Algeria", "Andorra", "Angola",
            "Anguilla", "Antigua and Barbuda", "Argentina",
            "Armenia", "Aruba",
            "Australia", "Austria", "Azerbaijan", "Bahamas",
            "Bahrain", "Bangladesh",
            "Barbados", "Belarus", "Belgium", "Belize", "Benin",
            "Bermuda", "Bhutan",
            "Bolivia (Plurinational State of)",
            "Bosnia and Herzegovina", "Botswana",
            "Brazil", "British Virgin Islands", "Brunei Darussalam",
            "Bulgaria", "Burkina Faso",
            "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Canada",
            "Cayman Islands",
            "Central African Republic", "Chad", "Chile",
            "China, Hong Kong SAR", "China, Macao SAR",
            "China, mainland", "Colombia", "Comoros", "Congo",
            "Cook Islands", "Costa Rica",
            "Côte d'Ivoire", "Croatia", "Cuba", "Cyprus", "Czechia",
            "Democratic People's Republic of Korea",
            "Democratic Republic of the Congo", "Denmark", "Djibouti",
            "Dominica", "Dominican Republic", "Ecuador",
            "Egypt", "El Salvador",
            "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia",
            "Fiji", "Finland", "France",
            "French Polynesia", "Gabon", "Gambia", "Georgia",
            "Germany", "Ghana", "Greece",
            "Greenland", "Grenada", "Guatemala", "Guinea",
            "Guinea-Bissau", "Guyana", "Haiti", "Honduras",
            "Hungary", "Iceland", "India", "Indonesia",
            "Iran (Islamic Republic of)",
            "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan",
            "Jordan", "Kazakhstan",
            "Kenya", "Kiribati", "Kosovo", "Kuwait", "Kyrgyzstan",
            "Lao People's Democratic Republic",
            "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya",
            "Liechtenstein", "Lithuania", "Luxembourg",
            "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali",
            "Malta", "Marshall Islands", "Mauritania",
            "Mauritius", "Mexico",
            "Micronesia (Federated States of)",
            "Monaco", "Mongolia", "Montenegro",
            "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia",
            "Nauru", "Nepal", "Netherlands",
            "Netherlands Antilles (former)", "New Caledonia",
            "New Zealand", "Nicaragua", "Niger", "Nigeria",
            "Norway", "Occupied Palestinian Territory", "Oman",
            "Pakistan", "Palau", "Panama",
            "Papua New Guinea", "Paraguay", "Peru", "Philippines",
            "Poland", "Portugal", "Puerto Rico",
            "Qatar", "Republic of Korea", "Republic of Moldova",
            "Romania", "Russian Federation", "Rwanda",
            "Saint Kitts and Nevis", "Saint Lucia",
            "Saint Vincent and the Grenadines", "Samoa", "San Marino",
            "Sao Tome and Principe", "Saudi Arabia", "Senegal",
            "Serbia", "Seychelles", "Sierra Leone", "Singapore",
            "Slovakia", "Slovenia", "Solomon Islands", "Somalia",
            "South Africa", "Spain", "Sri Lanka",
            "Sudan (former)", "Suriname", "Eswatini", "Sweden",
            "Switzerland", "Syrian Arab Republic",
            "Tajikistan", "Thailand", "North Macedonia",
            "Timor-Leste",
            "Togo", "Tonga", "Trinidad and Tobago",
            "Tunisia", "Turkey", "Turkmenistan",
            "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine",
            "United Arab Emirates", "United Kingdom",
            "United Republic of Tanzania", "United States of America",
            "Uruguay", "Uzbekistan", "Vanuatu",
            "Venezuela (Bolivarian Republic of)", "Viet Nam", "Yemen",
            "Zambia", "Zimbabwe"
          )
        ),
        p(strong("Gross Domestic Product -"), "Measures the total value of final goods and services produced within a given country."),
        p(strong("Gross National Income -"), "Measures all income of a country's residents and businesses, regardless of where it's produced."),
        p(strong("Gross Output (Agriculture) -")," Represents the production in monetary terms of farming and livestock raising during a given period"),
        p(strong("Gross Output (Agriculture, Forestry and Fishing) -")," The total value of products of farming, forestry, animal husbandry and fishery, 
          and total value of services rendered to support farming, forestry, animal husbandry and fishery activities.")
      ),
      mainPanel(
        plotOutput("bar_ploty")
      )
    )
  ),
  tabPanel(
    "Food Security",
    titlePanel("Food Security Indicators"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "indicator",
          "Food Security Indicator",
          choices = item_names
        ),
        htmlOutput("year_selector"),
        p(strong("Indicators")),
        
        # Indicator information
        p(strong("Average dietary energy supply adequacy")),
        p("The indicator expresses the Dietary Energy Supply (DES)
          as a percentage of the Average Dietary Energy Requirement (ADER)."),
        
        p(strong("Number of people undernourished")),
        p("Estimated number of people at risk of undernourishment.
          It is calculated by applying the estimated prevalence of
          undernourishment to total population in each period."),
        
        p(strong("Percent of arable land equipped for irrigation")),
        p("Ratio between arable land equipped for irrigation and total arable land."),
        
        p(strong("Value of food imports in total merchandise exports")),
        p("Value of food (excl. fish) imports over total merchandise exports."),
        
        p(strong("Percentage of population using at least basic drinking
                 water services")),
        p("See above."),
        
        p(strong("Percentage of population using at least basic sanitation services")),
        p("See above."),
        
        p(strong("Prevalence of obesity in the adult population.")),
        p("(Adult defined as over 18 years of age)")
        ),
      mainPanel(
        p("Food Security Indicators by Country"),
        rbokehOutput("plot_food")
      )
        )
  ),
  tabPanel(
    "Energy Use",
    titlePanel("Energy Use and Emissions in Agriculture"),
    h4("This graph allows you to look at the different ways countries consumed
       or emitted energy, using different energy sources."),
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
          # options = list(`actions-box` = TRUE),
          multiple = T
        ),
        selectInput(
          "element",
          label = "Select Domain",
          choices = c(
            "Consumption in Agriculture (in Terajoule)" =
              "Consumption in Agriculture",
            "Emissions (CH4) (Energy) (in gigagrams)" =
              "Emissions (CH4) (Energy)",
            "Emissions (CO2eq) from CH4 (Energy) (in gigagrams)" =
              "Emissions (CO2eq) from CH4 (Energy)",
            "Emissions (N2O) (Energy) (in gigagrams)" =
              "Emissions (N2O) (Energy)",
            "Emissions (CO2eq) from N2O (Energy) (in gigagrams)" =
              "Emissions (CO2eq) from N2O (Energy)",
            "Emissions (CO2) (Energy) (in gigagrams)" =
              "Emissions (CO2) (Energy)",
            "Emissions (CO2eq) (Energy) (in gigagrams)" =
              "Emissions (CO2eq) (Energy)",
            "Implied emission factor for CH4 (in kg/TJ)" =
              "Implied emission factor for CH4",
            "Implied emission factor for N2O (in kg/TJ)" =
              "Implied emission factor for N2O",
            "Implied emission factor for CO2 (in g/kWh)" =
              "Implied emission factor for CO2"
          ),
          selected = "Consumption in Agriculture"
        ),
        selectInput(
          "item",
          label = "Select Energy Type",
          choices = items,
          selected = "Electricity"
        )
      ),
      mainPanel(
        plotOutput("trend"),
        p(),
        p(em("Countries that dont utilize a type of energy will have
                     blank graphs for all domains."))
      )
    )
  )
)
