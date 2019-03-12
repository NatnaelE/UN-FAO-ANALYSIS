#GDP DATA

gdp_data <- read.csv("data/FAOSTAT_macroindicators.csv", stringsAsFactors = FALSE)

gdp_d <- gdp_data %>% 
  select(Area.Code, Area, Element,Item,Year, Unit, Value) %>% 
  filter(Year >= 2000, Year <= 2012)

countries <- gdp_d %>% 
  filter(Item == "Gross Domestic Product", Year == "2000", Area == "Afghanistan") %>% 
  select(Value)


 gdp_plot <-  ggplot(data = gdp_d) +
   geom_smooth(mapping = aes(
     x = Year,
     y = Value,
     color = Value
   )) +
   labs(
     x = "Year", 
     y = "GDP",
     title = "GDP and country"
   )
gdp_plot   
   
   
   
   
   
  

