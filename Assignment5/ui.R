#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

get_data <- function(num_records=-1) {
  fname <- "../source/owid-CO2-data.csv"
  df <- read.csv(fname, nrows=num_records)
  return(df)
}

co2_data <- get_data()

fdf2 <- co2_data %>% 
  select(country, year, co2_per_capita, co2)

y_values <- colnames(fdf2)

# Define UI for application that draws a histogram
page_1 <- tabPanel(title = "Introduction",

    # Application title
    titlePanel(strong("CO2 On The Rise")),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          h2("In 2020:"),
            htmlOutput("avg_message"),
            htmlOutput("med_message"),
            htmlOutput("min_message"),
            htmlOutput("max_message")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            img(src = "https://media.istockphoto.com/id/522731794/photo/smoke-stack.jpg?s=170667a&w=0&k=20&c=q_DPst6_UvZ8cbhgJi1tYmwfp0jMM2Pt5gqWSqS34og=")
        )
    )
)

page_2 <- tabPanel(title = "Data Vis",
      
    titlePanel(strong("Per Capita CO2, Visualized")),
    
    sidebarPanel(
      
      h2("Adjust the Graph"),
      
      shiny::radioButtons(
        "y_var",
        "Choose a tracked variable",
        c("co2", "co2_per_capita"),
        selected = "co2"
      ),
      
      sliderInput("time_range",
                  "Timeframe",
                  min = 1850,
                  max = 2021,
                  value = c(1850, 2021),
                  sep = ""
      ),
      
      selectizeInput("country_choice",
                     "Country/ies to Display",
                     unique(co2_data$country),
                     selected = "Malta",
                     multiple = TRUE)
      
    ),
    
mainPanel(
  plotlyOutput("plot"),
  h2("CO2 emissions, by the numbers"),
  p("What I find most interesting in the study of
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

ui <- navbarPage(theme = "slate",
  "A5",
  page_1,
  page_2
  )

