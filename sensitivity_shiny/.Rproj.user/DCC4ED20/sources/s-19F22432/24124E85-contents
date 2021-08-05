shinyServer(function(input, output) {

#Singles011--------------------------------------------------------------------  
  output$x_axis_text_011 <- renderText({
    paste0("x axis is:", input$x_axis_text_011)
  })
  output$y_axis_text_011 <- renderText({
    paste0("y axis is:", input$y_axis_text_011)
  })
  output$offset_magnitude_011 <- renderPrint(
    {input$offset_magnitude_011}
  )
  output$measurement_error_011 <- renderPrint(
    {input$measurement_error_011}
  )
  output$target_year_011 <- renderPrint(
    {input$target_year_011}
  )
  output$plotting_table_011 <- renderPlot({
    #Prep sims: filter fit slider choice and round where applicable
    sim_results_filtered <- singles_011_results %>%
      filter( 
        target_year >= input$target_year_011[1] & 
          target_year <= input$target_year_011[2],
        offset_magnitude >= input$offset_magnitude_011[1] & 
          offset_magnitude <= input$offset_magnitude_011[2],
        measurement_error >= input$measurement_error_011[1] & 
          measurement_error <= input$measurement_error_011[2]
        ) %>%
      mutate(
        target_year  = round(target_year, digits = -2),
        measurement_error = round(measurement_error),
        offset_magnitude  = round(offset_magnitude)
      )
    #Group on the desired parameter
    if (input$x_axis_text_011 == "offset_magnitude") {
      sim_results_grouped <- sim_results_filtered %>%
        group_by(offset_magnitude) %>%
        summarize(
          ratio_68_accurate = sum(accuracy_68)/n(),
          ratio_95_accurate = sum(accuracy_95)/n()
        )
    } else if (input$x_axis_text_011 == "measurement_error") {
      sim_results_grouped <- sim_results_filtered %>%
        group_by(measurement_error) %>%
        summarize(
          ratio_68_accurate = sum(accuracy_68)/n(),
          ratio_95_accurate = sum(accuracy_95)/n()
        )
    } else if (input$x_axis_text_011 == "target_year") {
      sim_results_grouped <- sim_results_filtered %>%
        group_by(target_year) %>%
        summarize(
          ratio_68_accurate = sum(accuracy_68)/n(),
          ratio_95_accurate = sum(accuracy_95)/n()
        )
    }
    
    sim_results_grouped %>%
      ggplot(aes(
        x = !!input$x_axis_text_011,
        y = !!input$y_axis_text_011
        )) +
      geom_point()

    
    
  })
  
})