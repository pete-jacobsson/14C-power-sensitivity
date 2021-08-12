shinyServer(function(input, output) {
  
  #Singles011--------------------------------------------------------------------  
  output$plot_011 <- renderPlot({
    
    #Prep sims: filter fit slider choice and round where applicable------------
    sim_results_filtered <- singles_011_results %>%
      filter( 
        target_year >= input$target_year_011[1] & 
          target_year <= input$target_year_011[2],
        offset_magnitude >= input$offset_magnitude_011[1] & 
          offset_magnitude <= input$offset_magnitude_011[2],
        measurement_error >= input$measurement_error_011[1] & 
          measurement_error <= input$measurement_error_011[2]
      )
    
    #Get the x_axis_label
    x_axis_label <- case_when(
      input$x_axis_011 == "target_year" ~ "Target year (cal BP)",
      input$x_axis_011 == "measurement_error" ~ "Measurement error (14C yrs)",
      input$x_axis_011 == "offset_magnitude" ~ "Offset magnitude (14C yrs)"
    )
    
    #Fork 1: plot ratio accurate-----------------------------------------------
    #Group on the desired parameter
    if (input$predicted_variable_011 == "accuracy") {
      
      #Step 1: group the data
      sim_results_grouped <- sim_results_filtered %>%
        #1.1 generate the bins to group on
        mutate(
          target_year  = plyr::round_any(target_year, input$rounding_slider*100),
          measurement_error = plyr::round_any(measurement_error, input$rounding_slider),
          offset_magnitude  = plyr::round_any(offset_magnitude, input$rounding_slider)
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
      
      #Step 4: set up the width of bin and the position of the geom_vline
      if (input$x_axis_011 ==  "target_year") {
        width_of_bin <- input$rounding_slider*100
      } else {
        width_of_bin = input$rounding_slider
      }
      
      if (input$hpd_area_011 == "hpd_68") {
        hline <- 0.68
      } else {
        hline <- 0.95
      }
      
      #Step 5: build the ggplot
      sim_results_grouped %>%
        ggplot(aes(x = x_axis, y = ratio_accurate)) +
        geom_hline(yintercept = hline) +
        geom_histogram(stat = "identity", width = width_of_bin) +
        ylim(c(0,1)) +
        xlab(x_axis_label) +
        ylab("Ratio accurate") +
        theme_classic()
      
    
    } else {
    # Fork 2: plot offset magnitude--------------------------------------------
      #Step 2: Move to long format for subsetting given hpd area choice
      sim_results_filtered <- sim_results_filtered %>%
        pivot_longer(cols = c(off_target_68, off_target_95),
                     names_to = "hpd_area",
                     values_to = "off_target")
      
      #Step 2: filter away the hpd area not chosen on the radio button
      if (input$hpd_area_011 == "hpd_68") {
        sim_results_filtered <- sim_results_filtered %>%
          filter(hpd_area == "off_target_68") %>%
          select(-hpd_area) 
      } else {
        sim_results_filtered <- sim_results_filtered %>%
          filter(hpd_area == "off_target_95") %>%
          select(-hpd_area)
      }
      
      #Step 3: shift the off-targetvalues to neg for neg offsets for target_yr observations
      if (input$x_axis_011 == "target_year") {
        sim_results_filtered <- sim_results_filtered %>%
          mutate(off_target = if_else(offset_magnitude < 0,
                                      off_target * -1,
                                      off_target))  
      }
      
      #Step 4: Do the basic plotting
      # off_target_plot <- sim_results_filtered %>%
      #   ggplot(aes(x = !!sym(input$x_axis_011), y = off_target)) +
      #   xlab(x_axis_label) +
      #   ylab("Off-target magnitude") +
      #   theme_bw()
      
      #Step 5: Color on demand
      if (input$off_target_color == "nope") {
        off_target_plot <- sim_results_filtered %>%
          ggplot(aes(x = !!sym(input$x_axis_011), y = off_target)) +
          geom_point() +
          xlab(x_axis_label) +
          ylab("Off-target magnitude") +
          theme_bw()
      } else {
        off_target_plot <- sim_results_filtered %>%
          ggplot(aes(x = !!sym(input$x_axis_011), y = off_target)) +
          geom_point(aes(col = abs(!!sym(input$off_target_color)))) +
          xlab(x_axis_label) +
          ylab("Off-target magnitude") +
          theme_bw()
      }
      
      
      #Step 6: Remove negatives from the y axis for target-yea x-axis
      
      if (input$x_axis_011 == "target_year" && input$hpd_area_011 == "hpd_68") {
        off_target_plot +
          scale_y_continuous(labels = c(300, 200, 100,  0, 100, 200, 300))
        off_target_plot
      } else if (input$x_axis_011 == "target_year" && input$hpd_area_011 == "hpd_95") {
        off_target_plot +
          scale_y_continuous(labels = c(200, 100,  0, 100, 200))
        off_target_plot
      } else {
        off_target_plot
      }
      
      
    }
    
    
  })
  
})