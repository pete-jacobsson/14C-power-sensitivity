shinyServer(function(input, output) {
  
  #Singles011--------------------------------------------------------------------  
  
  # new radio buttons check
  output$button_1 <- renderPrint(
    {input$predicted_variable_011}
  )
  output$button_2 <- renderPrint(
    {input$hpd_area_011}
  )
  
  output$offset_magnitude_011 <- renderPrint(
    {input$offset_magnitude_011}
  )
  output$measurement_error_011 <- renderPrint(
    {input$measurement_error_011}
  )
  output$target_year_011 <- renderPrint(
    {input$target_year_011}
  )
  
  output$plot_011 <- renderPlot({
    
    #Prep sims: filter fit slider choice and round where applicable
    sim_results_filtered <- singles_011_results %>%
      filter( 
        target_year >= input$target_year_011[1] & 
          target_year <= input$target_year_011[2],
        offset_magnitude >= input$offset_magnitude_011[1] & 
          offset_magnitude <= input$offset_magnitude_011[2],
        measurement_error >= input$measurement_error_011[1] & 
          measurement_error <= input$measurement_error_011[2]
      )

    
    #Fork 1: plot ratio accurate
    
    
    #Group on the desired parameter
    if (input$predicted_variable_011 == "accuracy") {
      
      #Step 1: group the data
      sim_results_grouped <- sim_results_filtered %>%
        #1.1 generate the bins to group on
        mutate(
          target_year  = round(target_year, digits = -2),
          measurement_error = round(measurement_error),
          offset_magnitude  = round(offset_magnitude)
        ) %>%
        #1.2 group and summarise (extract average accuracy over a given bin)
        group_by(!!sym(input$x_axis_011)) %>%
        summarise(
          ratio_68 = mean(accuracy_68),
          ratio_95 = mean(accuracy_95)
        ) %>%
        #1.3 Pivot to longer for future filtering
        pivot_longer(c(ratio_68, ratio_95), 
                     names_to = "hpd_area",
                     values_to = "ratio_accurate")
      
      #Step 2: change the column name to be flexible with ggplot
      colnames(sim_results_grouped)[1] <- "x_axis"
    
      #Step 3: filter away the hpd area not chosen on the radio button
      if (input$hpd_area_011 == "hpd_68") {
        sim_results_grouped <- sim_results_grouped %>%
          filter(hpd_area == "ratio_68") %>%
          select(-hpd_area)
      } else {
        sim_results_grouped <- sim_results_grouped %>%
          filter(hpd_area == "ratio_95") %>%
          select(-hpd_area)
      }
      
      #Step 4: set up the names for the x-axis and the width of bin
      x_axis_label <- case_when(
        input$x_axis_011 == "target_year" ~ "Target year (cal BP)",
        input$x_axis_011 == "measurement_error" ~ "Measurement error (14C yrs)",
        input$x_axis_011 == "offset_magnitude" ~ "Offset magnitude (14C yrs)"
      )
      
      if (input$x_axis_011 ==  "target_year") {
        width_of_bin <- 100
      } else {
        width_of_bin = 1
      }
      
      #Step 5: build the ggplot
      sim_results_grouped %>%
        ggplot(aes(x = x_axis, y = ratio_accurate)) +
        geom_histogram(stat = "identity", width = width_of_bin) +
        ylim(c(0,1)) +
        xlab(x_axis_label)
      
    
    }
    
    
    
    
    
    
  })
  
})