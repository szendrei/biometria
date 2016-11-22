library(shiny)
library(ggplot2)

shinyServer(function(input,output){
  
  #helpers for plot
  min.mean.sd.max <- function(x) {
    r <- c(min(x),mean(x) - sd(x),mean(x),mean(x) + sd(x),max(x))
    names(r) <- c("ymin","lower","middle","upper","ymax")
    r
  }
  
  #reactives
  numSliders <- reactive({
    as.integer(input$sampNum)
  })
  data <- reactive({
    value <- lapply(1:numSliders(), function(i) {
      req(mean <- as.integer(input[[paste(i)]]))
      c(rnorm(input$length, mean, input$sd))
    })
    group <- factor(rep(1:numSliders(), each=input$length))
    data <- data.frame("value"=unlist(value), "group"=group)
  })
  
  #for the inputs (means)
  output$sliders <- renderUI({
    lapply(1:numSliders(), function(i) {
      sliderInput(paste(i),label=paste(i,". minta átlaga:"),min=50,max=150,value=100)
    })
  })
  
  #outputs
  output$plot <- renderPlot({
    p1 <- ggplot(aes(y = value, x = factor(group)),data=data())
    p1 <- p1 + stat_summary(fun.data=min.mean.sd.max,geom="boxplot") + 
      geom_point(position="identity") + 
      ggtitle("Minták eloszlása, átlaga és szórása") +
      xlab("csoportok") + ylab("értékek")
    print(p1)
  })
  
  output$stats <- renderPrint({
    print(summary(m <- aov(value~group, data=data())))
    if (input$sampNum == 2) {
      cat("", "Két minta esetén ellenőrizheted, hogy a t-próba ugyanazt az eredmény adja:",sep='\n')
      t.test(value~group, data=data(), var.equal=T)
    }
  })
  
  output$stats2 <- renderPrint({
    if (input$sampNum != 2 && summary(aov(value~group, data=data()))[[1]][["Pr(>F)"]][1] < input$alpha/100) {
      print(TukeyHSD(aov(value~group, data=data())))
    }
  })
})