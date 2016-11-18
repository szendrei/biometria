library(shiny)
library(DT)

server <- function(input, output) {
  pop <- rnorm(100)    #minden alkalommal új populáció
  den <- density(pop)
  x <- seq(min(den$x),max(den$x),length.out=100)
  y <- dnorm(x)
  miny <- min(min(den$y),y); maxy <- max(max(den$y),y)
  
  #reactives
  samp <- reactive({
    replicate(input$obs, sample(pop,input$samp,replace=T))
  })
  bonf <- reactive({
    ifelse(input$corr,"bonferroni","none")
  })
  tests <- reactive({
    samp.data.frame <- data.frame(data=as.vector(samp()),
                                  key=as.vector(col(samp())))
    pairwise.t.test(samp.data.frame$data,samp.data.frame$key,pool.sd = F,p.adj = bonf())
  })
  
  #outputs
  output$popPlot <- renderPlot({
    plot(x,seq(miny,maxy,length.out=100),main="Populáció eloszlása",ylab="f(x)",xlab="x",type="n")
    lines(x,y,type="l",col="red")
    lines(den)
    rug(pop)
  })
  
  output$help <- renderText({
    bonff <- ifelse(isTRUE(bonf()),"Bonferroni korrekcióval","korrekció nélkül")
    paste("Párosított t-próbák",bonff)
  })

  output$summary <- renderDataTable({
    datatable(round(tests()$p.value,digits=4), 
              selection="none", options=list(ordering=F,pageLength=input$obs,dom="t")) %>% formatStyle(
      1:input$obs,
      color=styleInterval(.05,c("red","black"))
    )
  })
  
  output$samples <- renderDataTable({
    if (input$check) {
      datatable(format(samp(),digits=3),options=list(dom="t"))
    }
  })
  
}

ui <- fluidPage(
  titlePanel("Többszörös összehasonlítás problémája (elsőfajú hiba növekedése)"),
  p("Állítsd be a mintaszámot és a mintaméretet. A program minden módosításkor automatikusan új mintákat vesz a populációból."),
  p("Alul megnézheted a mintákat. A párosított t-próbák közül a ",span("pirosak",style="color:red"),"szignifikáns különbséget jeleznek. 
    Alapértelmezetten nincs korrekció, de megadhatod, hogy számoljon Bonferroni-korrekciót."),
  sidebarLayout(position="right",
    sidebarPanel(
      sliderInput("obs", "Minták száma:",min=1,max=100,value=20),
      sliderInput("samp", "Mintaméret:",min=1,max=20,value=10)
      ),
      mainPanel(
        plotOutput("popPlot"),
        checkboxInput("corr","Bonferroni korrekció"),
        textOutput("help"),
        dataTableOutput("summary"),
        checkboxInput("check","Minták megtekintése"),
        dataTableOutput("samples")
      )
  )
)

shinyApp(ui = ui, server = server)