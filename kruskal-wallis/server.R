library(shiny)
library(ggplot2)
library(dunn.test)

#beta distribution params
a <- 1; b <- 6; ncp <- 2
#plot colors
x <- seq(0,1,.005)
p <- qplot(x, geom="blank")
cols <- c('black','red','blue','green','purple','pink','orange','brown','lightgreen','navy')

shinyServer(function(input,output){
  
  #reactives
  numSliders <- reactive({
    as.integer(input$sampNum)
  })
  data <- reactive({
    value <- lapply(1:numSliders(), function(i) {
      req(mean <- as.integer(input[[paste(i)]]))
      c(rbeta(input$length, a, b, ncp=ncp) + mean)
    })
    group <- factor(rep(1:numSliders(), each=input$length))
    data <- data.frame("value"=unlist(value), "group"=group)
  })
  
  #for the inputs (means)
  output$sliders <- renderUI({
    lapply(1:numSliders(), function(i) {
      sliderInput(paste(i),label=paste(i,". minta mediánja:"),min=50,max=150,value=100)
    })
  })
  
  output$plot <- renderPlot({
    boxplot(value ~ group, data=data())
  })

  output$stats <- renderPrint({
    print(test <- kruskal.test(value~group, data=data()))
    if (test$p.value < input$alpha/100) {
      cat('Post-hoc teszt eredménye:\nDunn teszt')
      dunn.test(data()$value,data()$group,method = 'bonferroni',kw=F)
    }
  })
})