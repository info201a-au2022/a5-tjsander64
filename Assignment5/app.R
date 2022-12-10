
library("shiny")
library("tidyverse")
library("plotly")
library("rsconnect")
library("shinythemes")
library("rlang")
library("ggplot2")
library("dplyr")

source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)
runApp(getwd())

