# Exercise 5: complex Shiny UI layouts

# Load libraries so they are available
library("shiny")
library("tidyverse")
library("plotly")
library("rsconnect")

# Use source() to execute the `app_ui.R` and `app_server.R` files. These will
# define the UI value and server function respectively.
source("ui.R")
source("server.R")

# You will need to fill in the `app_ui.R` file to create the layout.
# Run the app through this file.

# Create a new `shinyApp()` using the loaded `ui` and `server` variables
shinyApp(ui = ui, server = server)
runApp(getwd())

