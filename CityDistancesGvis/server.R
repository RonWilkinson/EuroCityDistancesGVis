#  Server side of Shiney application to show the distances of major European cities within a chosen radius
#  of a starting city.

library(shiny)
library(googleVis)
library(dplyr)
data("eurodist")

# European city distances dataset

eurodist.df <- data.frame(as.matrix(eurodist))

shinyServer( function(input, output) {

        output$heading <- renderText(paste( "Distances from", input$center))

        # Construct table of cities within radius of central city
        output$citiesList <- renderTable({

                center <- input$center
                radius <- input$radius

                px <- select(eurodist.df, Distance=matches(center))
                px <- mutate(px, City=rownames(px), Distance)
                px1 <- filter(px,Distance<=radius & Distance > 0)
                px1 <- select(px1, City, Distance)

                if(length(px1$City) > 0) {
                        px1$units="km"
                        return(px1)
                }
                else return(data.frame(Message=paste("No other cities in list within", radius, "km of", center)))
        })

        #Construct map of cities within radius of central city
        output$citiesmap <- renderGvis({

                center <- input$center
                radius <- input$radius

                pm <- select(eurodist.df, Distance=matches(center))
                pm$City <- rownames(pm)
                pm["Lyons", "City"] <- "Lyons, France"
                pm["Cologne", "City"] <- "Cologne, Germany"
                pm1 <- select(pm, City, Distance)
                pm1$hover <- paste(pm1$City, pm1$Distance,"km")
                pm1 <- filter(pm1, Distance <= radius)

                if (length(pm1$City) > 1)
                        gvisMap(pm1, "City","hover")
                else
                        gvisMap(data.frame(region=character(),hover=character()),"region","hover")

        })
})
