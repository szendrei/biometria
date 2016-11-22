library(shiny)

shinyUI(fluidPage(
  titlePanel("Kruskal-Wallis teszt"),
  sidebarLayout(
    sidebarPanel(
      # adatok bevitele
      # tabokon: R-ből olvas, fájlból olvas, manuális
      # ha manuális: plusz iconos gombocska, hogy több adat (lásd ANOVA a több input kezelésére)
    ),
    mainPanel(
      # plot
      # stats: kw teszt
      # ha szignifikáns: dunn test
    )
  )
))