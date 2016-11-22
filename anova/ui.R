library(shiny)

shinyUI(fluidPage(
  titlePanel("ANOVA"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sampNum",label="Minták száma:",min=2,max=10,value=4),
      sliderInput("length",label="Minták elemszáma:",min=3,max=50,value=30),
      sliderInput("sd",label="Minták szórása:",min=1,max=50,value=10),
      uiOutput("sliders")
    ),
    mainPanel(
      plotOutput("plot"),
      verbatimTextOutput("stats")
    )
  )
))