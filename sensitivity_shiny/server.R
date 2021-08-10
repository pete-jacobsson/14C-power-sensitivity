shinyServer(function(input, output) {

#Singles011--------------------------------------------------------------------  

  output$offset_magnitude_011 <- renderPrint(
    {input$offset_magnitude_011}
  )
  output$measurement_error_011 <- renderPrint(
    {input$measurement_error_011}
  )
  output$target_year_011 <- renderPrint(
    {input$target_year_011}
  )
  output$plotting_table_011 <- renderTable({

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

    sim_results_grouped <- sim_results_filtered %>%
      group_by(!!sym(input$x_axis_011)) %>%
      summarise(
        ratio_68 = mean(accuracy_68),
        ratio_95 = mean(accuracy_95)
      )
    #head(sim_results_filtered, 10)


    
    
  })
  
})