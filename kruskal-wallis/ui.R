library(shiny)

shinyUI(fluidPage(
  titlePanel("Kruskal-Wallis próba"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sampNum",label="Minták száma:",min=2,max=10,value=4),
      sliderInput("length",label="Minták elemszáma:",min=3,max=50,value=30),
      uiOutput("sliders")
    ),
    mainPanel(
      plotOutput("plot"),
      sliderInput("alpha",label="α értéke:",min=1,max=100,value=5,post="%"),
      verbatimTextOutput("stats")
    )
  )
))