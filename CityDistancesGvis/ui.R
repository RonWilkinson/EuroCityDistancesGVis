#  User interface side of Shiney application to show the distances of major European cities within a chosen radius
#  of a starting city.

library(shiny)

# European city distances dataset
data(eurodist)
eurodist.m <- as.matrix(eurodist)

# Define UI for getting starting city and radius and displaying chart and map of cities within radius
shinyUI(fluidPage(

        # Application title
        titlePanel("Distances Between European Cities"),


        # Sidebar for input
        sidebarLayout(
                sidebarPanel(
                        # Select starting city from dropdown list of major European cities
                        selectInput("center", "Starting City", rownames(eurodist.m), selected="Paris"),

                        # Select radius using slider bar input
                        sliderInput("radius",
                                    "Distances to other European cities within a radius of",
                                    min = 0,
                                    max = round(max(eurodist.m)+100,-2),
                                    value = 750,
                                    step=10,
                                    post=" km")
                ),

                # Main panel to show output
                mainPanel(
                        h3(textOutput("heading")),
                        # Table of cities within chosen radius of central city
                        tableOutput("citiesList"),

                        # Map of cities within chosen radius of central city
                        htmlOutput("citiesmap")
                )
        )
))
