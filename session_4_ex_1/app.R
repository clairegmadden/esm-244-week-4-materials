
#My first app example!


# attach packages
library(shiny)
library(tidyverse)
library(here)

# read in penguins.csv

penguins <- read_csv(here("session_4_ex_1", "penguins.csv"))


# create the 'ui' = user interface
# fluidPage() = user interface will update based on changes to the size of the browswer page
# if you want choices to appear differently than how they are stored in the dataset, within choices = c("what you want to show up" = "exactly how it is stored in the data")
ui <- fluidPage(
  titlePanel("This is my awesome title!"),
  sidebarLayout(
    sidebarPanel("Here are my widgets!",
                 # add some radio buttons to the widget sidepanel
                 radioButtons(inputId = "species",
                              label = "Choose penguin species:",
                              choices = c("Adelie", "Gentoo", "Chinstrap")),
                 # add a dropdown menu 
                 selectInput(inputId = "pt_color", 
                             label = "Select a point color!",
                             choices = c("RAD RED" = "red",
                                         "PRETTY PURPLE" = "purple",
                                         "ORAAAANGE!" = "orange"))),
    mainPanel("Here is my graph!",
              # add reactive graph we made in the server here
              plotOutput(outputId = "penguin_plot"))
  )
) 


# create the 'server' = behind the scenes stuff, anything that happens in the server has to go within {}
server <- function(input, output){
  # create a reactive data frame:
  penguin_select <- reactive({
    penguins %>% 
      filter(sp_short == input$species)
  })
  # create an output called pengiun_plot
  output$penguin_plot <- renderPlot({
    # when referencing a reactive dataframe, you have to have () at the end of the name
    # once in the reactive renderPlot, can code things like you would normally
    ggplot(data = penguin_select(), aes(x = flipper_length_mm, y = body_mass_g))+
      # add geometry and then set color based on dropdown menu set up in ui
      geom_point(color = input$pt_color)
    
  })
  
}


# let R know that we want to combine the user interface and the server into an app:
shinyApp(ui = ui, server = server)








