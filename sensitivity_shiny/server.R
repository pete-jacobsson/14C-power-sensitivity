shinyServer(function(input, output) {

#Singles011--------------------------------------------------------------------  
  output$x_axis_text_011 <- renderText({
    paste0("X axis is:", input$x_axis_text_011)
  })
  output$y_axis_text_011 <- renderText({
    paste0("y axis is:", input$y_axis_text_011)
  })
  
})