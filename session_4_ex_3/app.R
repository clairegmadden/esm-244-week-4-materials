
# third shiny example!


# attach packages
library(shiny)
library(shinydashboard)
library(tidyverse)
library(here)
library(shinythemes)



# using existing dataset 

# create ui

ui <- dashboardPage(
  dashboardHeader(title = "Star Wars"),
  # add a menu in the sidebar instead of tabs across the top
  dashboardSidebar(
    sidebarMenu(
      menuItem("Homeworld", tabName = "homes", icon = icon("jedi")), #font-awesome is not working for me
      menuItem("Species", tabName = "species", icon = icon("pastafarianism"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "homes",
        fluidRow(
          box(title = "Homeworld Graph", 
              selectInput("sw_species", "Choose species", 
                          # unique() will report all unique entries within a column
                          choices = c(unique(starwars$species)))),
          box(plotOutput(outputId = "sw_plot"))
        )
      )
      # could add another tab item here for the species tab
    )
  )
  
)

# create server
server <- function(input, output){
  # create a reactive df and plot of homeworlds that each species is from!
  
  species_df <- reactive({
    starwars %>% 
      filter(species == input$sw_species)
  })
  
  output$sw_plot <- renderPlot({
    ggplot(data = species_df(), aes(x = homeworld))+
      geom_bar()+
      coord_flip()
  })
  
  
  
}


# tell R that these are a shiny app that should work together

shinyApp(ui = ui, server = server)





