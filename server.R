# Food security indicators test Shiny App server

library(dplyr)
library(ggplot2)
library(rbokeh)
library(tidyr)
library(stringr)
library(shiny)

item_by_country <- clean_food_data %>%
  group_by(Area) %>%
  filter(Item.Code == 21010) %>%
  filter(Year.Code == 20002002) %>%
  ungroup()
item_by_country$Value <- as.double(item_by_country$Value)
item_by_country <- item_by_country %>%
  left_join(country_region, by = "Area")
item_by_country

# Read in data
food_data <- read.csv("data/FAOSTAT_foodsecurity.csv", stringsAsFactors = FALSE)
country_region <- read.csv("data/country_region.csv", stringsAsFactors = FALSE)
country_region <- country_region %>%
  select(name, region)
names(country_region) <- c("Area", "region")

# Clean up
clean_food_data <- food_data %>%
  select(Area.Code, Area, Item.Code, Item, Year.Code, Year, Unit, Value)
clean_population_data <- population_data %>%
  select(Area.Code, Area, Element, Year, Unit, Value)

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

# Join population and food indicators
# clean_food_data <- left_join(clean_food_data, clean_population_data, by = "Area.Code")

# TODO
# Write a function to take in year, item
# Make the two dropdown dependent on eachother to differentiate averages vs single years

server <- function(input, output) {

  # Try to make something of this mess
  item_by_country <- reactive({
    item_by_country <- clean_food_data %>%
      # spread(key = Item, value = Value) %>%
      group_by(Area) %>%
      filter(Item == input$indicator) %>%
      filter(str_detect(Year, input$year)) %>%
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
      inputId = "year",
      label = "Year",
      choices = years_available(),
      selected = years_available()[1]
    )
  })

  # Create the plot
  output$plot <- renderRbokeh({
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
}
