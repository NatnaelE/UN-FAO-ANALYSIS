# Food security indicators test Shiny App UI

library(dplyr)
library(ggplot2)
library(rbokeh)
library(tidyr)
library(shiny)

source("server.R")

ui <- fluidPage(
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
      rbokehOutput("plot")
    )
  )
)
