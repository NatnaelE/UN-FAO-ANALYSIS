library("shiny")
library("dplyr")
library("leaflet")
library("stringr")
library("rbokeh")
library("tidyr")
library("ggplot2")
library("ggmap")
library("plotly")

# LOAD ALL DATA SETS HERE AT THE BEGINNING
countries <- read.csv("data/countries_long_lat.csv", stringsAsFactors = FALSE)
full_pop_data <- read.csv("data/FAOSTAT_population.csv", stringsAsFactors = FALSE)
full_land_data <- read.csv("data/FAOSTAT_landuse.csv", stringsAsFactors = FALSE)
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv", stringsAsFactors = FALSE)
food_data <- read.csv("data/FAOSTAT_foodsecurity.csv", stringsAsFactors = FALSE)
country_region <- read.csv("data/country_region.csv", stringsAsFactors = FALSE)

my_server <- function(input, output) {
  #--------------------------------------------CHOROPLETH PAGE------------------------------------------------------------------------------------------------- 
  output$choropleth <- renderPlotly({
    land_data <- full_land_data %>%
      select(
        -Domain.Code, -Domain, -Area.Code, -Element.Code, -Item.Code,
        -Year.Code, -Unit, -Flag, -Flag.Description
      ) %>%
      filter(Year >= 2000, Year <= 2016, Element != "Share in Forest land")

    colnames(land_data)[colnames(land_data) == "Area"] <- "Country"

    countries <- read.csv("data/countries_long_lat.csv", stringsAsFactors = FALSE) %>%
      select(-Alpha.2.code, -Alpha.3.code, -Numeric.code, -Icon)


    tot_land_data <- left_join(land_data, countries)

    share_agricultural_land <- tot_land_data %>% filter(Element == "Share in Agricultural land")
    # INPUT---------------------------------------
    agri_element_map <- share_agricultural_land %>%
      filter(Item == input$itemn, Year == input$yearn) %>%
      select(-Latitude..average., -Longitude..average.)

    colnames(df)[1] <- "Country"
    df[15, 1] <- "Bahamas"
    df[46, 1] <- "Congo"
    df[47, 1] <- "Democratic Republic of the Congo"
    df[74, 1] <- "Gambia"
    df[134, 1] <- "Micronesia (Federated States of)"
    df[165, 1] <- "Russian Federation"
    df[177, 1] <- "Serbia and Montenegro"
    df[190, 1] <- "Sudan (former)"
    df[195, 1] <- "Syrian Arab Republic"
    df[198, 1] <- "United Republic of Tanzania"
    df[212, 1] <- "United States of America"
    df[216, 1] <- "Venezuela (Bolivarian Republic of)"
    df[217, 1] <- "Viet Nam"
    df[218, 1] <- "United States Virgin Islands"
    df[25, 1] <- "Bolivia (Plurinational State of)"
    df[30, 1] <- "Brunei Darussalam"
    df[50, 1] <- "Côte d'Ivoire"
    df[55, 1] <- "Czechia"
    df[109, 1] <- "Democratic People's Republic of Korea"
    df[95, 1] <- "Iran (Islamic Republic of)"
    df[108, 1] <- "Republic of Korea"
    df[113, 1] <- "Lao People's Democratic Republic"
    df[123, 1] <- "North Macedonia"
    df[135, 1] <- "Republic of Moldova"
    df <- df[-c(33, 53, 7, 67, 74, 78, 80, 84, 90, 110, 122, 136, 138, 169, 181, 187, 192, 196, 207)]


    chorodata <- left_join(agri_element_map, df) %>% na.omit()


    l <- list(color = toRGB("grey"), width = 0.5)

    # specify map projection/options
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type = "Mercator")
    )

    choropleth <- plot_geo(chorodata) %>%
      add_trace(
        z = ~Value, color = ~Value, colors = "Greens",
        text = ~Country, locations = ~CODE, marker = list(line = l)
      ) %>%
      colorbar(title = paste0("% of ", input$itemn), ticksuffix = "%") %>%
      layout(
        title = paste0("Percentage of ", input$itemn, " Worldwide in ", input$yearn),
        geo = g
      )

    choropleth
  })
  #--------------------------------------------END CHOROPLETH PAGE--------------------------------------------------------------------------------------------  

  #--------------------------------------------MACROINDICATOR PAGE--------------------------------------------------------------------------------------------
  gdp_data <- read.csv("data/FAOSTAT_macroindicators.csv", stringsAsFactors = FALSE)
  output$bar_ploty <- renderPlot({
    gdp_d <- gdp_data %>%
      select(Area.Code, Area, Element, Item, Year, Unit, Value) %>%
      filter(Year >= 2000, Year <= 2016, 
             Item %in% c("Gross Domestic Product", "Gross Output (Agriculture)", "Gross Output (Agriculture, Forestry and Fishing)", "Gross National Income"))
    countriess <- gdp_d %>%
      filter(Area == input$country_y) 

    j <- ggplot() + geom_bar(aes(y = Value, x = Year, fill = Item), data = countriess, stat = "identity")+
      labs(
        title = paste0("Graph of ", input$country_y, "'s Economic Outputs, Products and Income "),
        x = "Year",
        y = "Value in Millions of Dollars"
      )

    j
  })

  #--------------------------------------------END MACROINDICATOR PAGE----------------------------------------------------------------------------------------

  #--------------------------------------------FOOD-SECURITY PAGE--------------------------------------------------------------------------------------------- 
    # Read in data
    food_data <- read.csv("data/FAOSTAT_foodsecurity.csv", stringsAsFactors = FALSE)
    country_region <- read.csv("data/country_region.csv", stringsAsFactors = FALSE)
    
    #clean region data
    country_region <- country_region %>%
      select(name, region)
    names(country_region) <- c("Area", "region")
    
    # Clean up
    clean_food_data <- food_data %>%
      select(Area.Code, Area, Item.Code, Item, Year.Code, Year, Unit, Value)
    
    # Vector of item names for the dropdown
    grouped_by_item <- clean_food_data %>%
      group_by(Item) %>%
      filter(Area == "Afghanistan") %>%
      filter(Item.Code == 21010 |
               Item.Code == 21034 |
               Item.Code == 210011 |
               Item.Code == 21034 |
               Item.Code == 21033 |
               Item.Code == 21047 |
               Item.Code == 21048 |
               Item.Code == 21042) %>% # Select indicators
      filter(str_detect(Year.Code, "2000"))
    item_names <- pull(select(grouped_by_item, Item))
    
    # Try to make something of this mess
    item_by_country <- reactive({
      item_by_country <- clean_food_data %>%
        # spread(key = Item, value = Value) %>%
        group_by(Area) %>%
        filter(Item == input$indicator) %>%
        filter(str_detect(Year, input$year_food)) %>%
        ungroup()
      item_by_country$Value <- as.double(item_by_country$Value)
      item_by_country <- item_by_country %>%
        left_join(country_region)
      item_by_country
    })
    
    # Create the dropdown for years
    output$year_selector <- renderUI({
      
      # Create the reactive values for the year dropdown
      years_available <- reactive({
        years_available <- clean_food_data %>%
          filter(Item == input$indicator, Area == "Afghanistan") %>%
          select(Year)
        year_vector <- pull(years_available)
        year_vector
      })
      
      # Create the dropdown itself
      selectInput(
        inputId = "year_food",
        label = "Year",
        choices = years_available(),
        selected = years_available()[1]
      )
    })
    
    # Create the plot
    output$plot_food <- renderRbokeh({
      p <- figure() %>%
        ly_points(
          Area, Value,
          data = item_by_country(),
          color = region,
          hover = list(Area, Value)
        ) %>%
        y_axis(label = input$indicator) %>%
        x_axis(visible = FALSE)
      p
    })
 
  #--------------------------------------------END FOOD-SECURITY PAGE-----------------------------------------------------------------------------------------

  #--------------------------------------------ENERGYUSE PAGE-------------------------------------------------------------------------------------------------
  energy <- read.csv("data/FAOSTAT_data_3-12-2019.csv", stringsAsFactors = F)
  energy[is.na(energy)] <- 0
  energy <- energy %>%
    filter(Unit != "million kWh")

  filtered <- reactive({
    data <- energy %>%
      filter(Year >= input$year[1], Year <= input$year[2], Element == input$element, Country == input$country, Item == input$item)
    data
  })

  filtered_one <- reactive({
    data_a <- filtered() %>%
      group_by(Year) %>%
      summarise(Value = sum(Value), Unit = unique(Unit))
    data_a
  })

  output$trend <- renderPlot({
    p <- ggplot(data = filtered_one(), mapping = aes_string(x = "Year", y = "Value")) +
      geom_point() +
      geom_line() +
      scale_x_continuous(breaks = c(2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012))
    p
  })
}
  #--------------------------------------------END ENERGYUSE PAGE---------------------------------------------------------------------------------------------