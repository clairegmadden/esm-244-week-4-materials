
# second app example!

# attach packages
library(shiny)
library(tidyverse)
library(here)
library(shinythemes)

# using existing dataset in dplyr called "diamonds"


ui <- navbarPage("Navigation Bar!",
                 # update the theme of your app!
                 theme = shinytheme("cyborg"),
                 # add some tabs to create different panels in ui
                 tabPanel("First tab!",
                          # h1 is largest header option, h2 is smaller etc
                          # p indicates just regular paragraph text
                          h1("Some giant text"),
                          p("Here is some regular text"),
                          plotOutput(outputId = "diamond_plot")),
                 tabPanel("Second tab!",
                          sidebarLayout(
                            sidebarPanel("Some text!",
                                         # add a checkbox widget!
                                         checkboxGroupInput(inputId = "diamondclarity", 
                                                            "Choose some!", # this makes your label
                                                            choices = c(levels(diamonds$clarity)))),
                            mainPanel("Main panel text.",
                                      plotOutput(outputId = "diamond_plot_2"))
                          ))
                 )


server <- function(input, output){
  # create some graph output to show up in ui
  output$diamond_plot <- renderPlot({
    
    ggplot(data = diamonds, aes(x = carat, y = price))+
      geom_point(aes(color = clarity)) # changing something based on a variable must go within aes()
  })
  
  diamond_clarity <- reactive({
    diamonds %>% 
      # keep anything in the clarity column that matches the selection in the widget we made to select clarity 
      filter(clarity %in% input$diamondclarity)
  })
  
  output$diamond_plot_2 <- renderPlot({
    ggplot(data = diamond_clarity(), aes(x = clarity, y = price))+
      geom_violin(aes(fill = clarity))
  })
  
}



shinyApp(ui = ui, server = server)




