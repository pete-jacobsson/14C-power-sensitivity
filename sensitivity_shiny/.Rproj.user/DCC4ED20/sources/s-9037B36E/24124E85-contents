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
    #Set up the switch function for the Plotting axes selection
    x_axis <- switch(input$x_axis_011, "offset_magnitude")
    y_axis <- switch(input$y_axis_011)
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
        group_by(colnames(singles_011_results)[input$x_axis_text_011]) %>%
        summarize(
          ratio_68_accurate = sum(accuracy_68)/n(),
          ratio_95_accurate = sum(accuracy_95)/n()
        )
    head(sim_results_grouped, 10)


    
    
  })
  
})