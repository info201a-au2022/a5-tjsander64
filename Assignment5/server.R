#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library("shiny")
library("tidyverse")
library("plotly")
library("rsconnect")
library("shinythemes")
library("rlang")
library("ggplot2")
library("dplyr")

read.csv("../source/owid-CO2-data.csv")

get_data <- function(num_records=-1) {
  fname <- "../source/owid-CO2-data.csv"
  df <- read.csv(fname, nrows=num_records)
  return(df)
}


co2_data <- get_data()



## WRANGLING

# Dataframes for Page 2
recent_snapshot <- co2_data %>% 
  filter(year == max(year)) 

filtered_df <- recent_snapshot %>% 
  select(country, population, co2, co2_per_capita, co2_per_gdp)

fdf2 <- co2_data %>% 
  select(country, year, co2_per_capita, co2)

plot_df <- reactive


# Key stats for Page 1
average_CO2_pc <- mean(filtered_df$co2_per_capita, na.rm = TRUE)

median_CO2_pc <- median(sort(filtered_df$co2_per_capita)[-1], na.rm = TRUE)

median_pc_country <- filtered_df %>% 
  filter(co2_per_capita == median_CO2_pc) %>% 
  pull(country)

max_pc <- max(filtered_df$co2_per_capita, na.rm = TRUE)

max_pc_country <- filtered_df %>% 
  filter(co2_per_capita == max_pc) %>% 
  pull(country)

min_pc <- min(filtered_df$co2_per_capita, na.rm = TRUE)

min_pc_country <- filtered_df %>% 
  filter(co2_per_capita == min_pc) %>% 
  pull(country)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Page 1 Values

    output$avg_message <- renderText({
      message_text <- paste("The <b>average</b> per-capita emissions of a country is ",
                            average_CO2_pc, " tons/person.")
      message_text
    })
    
    output$med_message <- renderText({
      message_text <- paste("The <b>median</b> country in terms of per capita emissions
                            is ", median_pc_country, " with ", median_CO2_pc, " 
                            tons/person.")
      message_text
    })
    
    output$max_message <- renderText({
      message_text <- paste("The <b>largest</b> country in terms of per capita emissions
                            is ", max_pc_country, " with ", max_pc, " 
                            tons/person.")
      message_text
    })
    
    output$min_message <- renderText({
      message_text <- paste("The <b>smallest</b> country in terms of per capita emissions
                            is ", min_pc_country, " with ", min_pc, " 
                            tons/person.")
      message_text
    })

    # Page 2 Graph
    
    plot_df <- reactive({
      fdf2 %>% 
        filter(year %in% c(input$time_range[1]:input$time_range[2]),
               country %in% input$country_choice)
    })
    
    output$plot <- renderPlotly({ggplotly(ggplot(data = plot_df(),
                                                 mapping=aes(x = year,
                                                             y = .data[[input$y_var]],
                                                             color = country,
                                                             )) +
                      geom_point() +
                      geom_smooth() +
                      labs(
                        title = "CO2 stats over time, by country",
                        caption = p("What I find most interesting in the study of
                                    greenhouse gas emissions is the comparison 
                                    between co2 emissions and per capita co2 
                                    emissions because of the questions it raises.
                                    It's important to understand emissions both 
                                    universally and contextually. Taking the example
                                    of China, we should understand that that country
                                    is responsible for the most yearly emissions
                                    on earth, but furthermore, as the largest 
                                    country, it still contributes significantly
                                    less carbon dioxide per capita compared to,
                                    say, the US. That being said, the US's 
                                    emissions per capita are falling while China's
                                    are still growing, so we'll see where we're at
                                    in a few years.")
                        
                      )
    )

    })

})
