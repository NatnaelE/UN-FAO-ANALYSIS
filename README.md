#PROJECT URL : https://natnaele.shinyapps.io/UNFAO-Analysis/




# Project Proposal

### Project description

For our project we will be working with the [UN Food and Agriculture Datasets](http://www.fao.org/faostat/en/#data) which are collected and compiled by the Food and Agriculture Organization of the United Nations. More specifically, we will be working with the following datasets from this database, although we may end up including more depending on how the inquiry develops:

**Annual Population**

Tracks the population of countries and regions with data going back to the 1960s.

**Land Use**

Data outlining the use of land by country since the 1960s with regards to the food system (e.g. land for growing crops, processing food, etc.)

**Macro Indicators**

Data on economic macro-indicators such as GDP, GDP per capita, power of local currency, etc.

**Energy use**

A breakdown of the energy use for agricultural purposes and what emissions are generated.

**Suite of food security indicators**

Indicators for malnutrition, obesity, caloric intake, and other food related health issues going back to 1999.

Our intended audience is anyone who wishes to be informed about the state of the global food system as it relates to socio-economic conditions. We do not intend to target policymakers or anyone of that nature in particular, as they have access to this data and much more already. Instead, we would like to provide aggregated and insightfully connected information to people who are interested or concerned about socioeconomic conditions and the global food system.

Possible questions that our project will answer for our audience include:
- What is the relationship between GDP per capita and food security indicators?
- Is there a connection between the ratio of urban and rural population and food security? What about GDP per capita?
- Is there a connection between GDP and agricultural land use? What about emissions?

### Technical description
All of the datasets on the UN website are contained in static .csv files, so we will be reading data in from there. For the most part datasets are fairly well organized, although we may have to do a fair bit of joining and grouping to tailor them for our purposes. As far as new libraries, we will need to find an interactive chart package that is not `plotly`, as our group does not find working with `plotly` very enjoyable. We will definitely be using `leaflet` extensively or we may need to find another mapping library depending on how it goes (one possibility, as our data is global, is `rworldmap`).

The major challenges that we anticipate is first theoretical - the data we are working with is complex and nuanced and we will need to do some research to familiarize ourselves with the economic indicators involved. Second, the challenge will be presenting the data in a way which does not overwhelm the user with information and structuring it in a way that is intuitive.
