library(shiny)
      
function(input, output) {
  output$regija1 <- renderPlot({
    graf.regije(input$regija)
  })
  output$avto <- renderPlot({
    graf_avto(input$Leto) + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
  
}
