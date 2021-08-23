shinyServer(function(input, output) {
  
  #Singles011 Core plotting----------------------------------------------------  
  output$plot_011_eda <- renderPlot({
    
    #Prep sims: filter fit slider choice and round where applicable------------
    sim_results_filtered <- singles_011_results %>%
      filter( 
        target_year >= input$target_year_011_eda[1] & 
          target_year <= input$target_year_011_eda[2],
        offset_magnitude >= input$offset_magnitude_011_eda[1] & 
          offset_magnitude <= input$offset_magnitude_011_eda[2],
        measurement_error >= input$measurement_error_011_eda[1] & 
          measurement_error <= input$measurement_error_011_eda[2]
      )
    
    #Get the x_axis_label
    x_axis_label <- case_when(
      input$x_axis_011_eda == "target_year" ~ "Target year (cal BP)",
      input$x_axis_011_eda == "measurement_error" ~ "Measurement error (14C yrs)",
      input$x_axis_011_eda == "offset_magnitude" ~ "Offset magnitude (14C yrs)"
    )
    
    #Fork 1: plot ratio accurate-----------------------------------------------
    #Group on the desired parameter
    if (input$predicted_variable_011_eda == "accuracy") {
      
      #Step 1: group the data
      sim_results_grouped <- sim_results_filtered %>%
        #1.1 generate the bins to group on
        mutate(
          target_year  = plyr::round_any(target_year, input$rounding_slider_011_eda*100),
          measurement_error = plyr::round_any(measurement_error, input$rounding_slider_011_eda),
          offset_magnitude  = plyr::round_any(offset_magnitude, input$rounding_slider_011_eda)
        ) %>%
        #1.2 group and summarise (extract average accuracy over a given bin)
        group_by(!!sym(input$x_axis_011_eda)) %>%
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
      if (input$hpd_area_011_eda == "hpd_68") {
        sim_results_grouped <- sim_results_grouped %>%
          filter(hpd_area == "ratio_68") %>%
          select(-hpd_area)
      } else {
        sim_results_grouped <- sim_results_grouped %>%
          filter(hpd_area == "ratio_95") %>%
          select(-hpd_area)
      }
      
      #Step 4: set up the width of bin and the position of the geom_hline
      if (input$x_axis_011_eda ==  "target_year") {
        width_of_bin <- input$rounding_slider_011_eda*100
      } else {
        width_of_bin = input$rounding_slider_011_eda
      }
      
      if (input$hpd_area_011_eda == "hpd_68") {
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
      if (input$hpd_area_011_eda == "hpd_68") {
        sim_results_filtered <- sim_results_filtered %>%
          filter(hpd_area == "off_target_68") %>%
          select(-hpd_area) 
      } else {
        sim_results_filtered <- sim_results_filtered %>%
          filter(hpd_area == "off_target_95") %>%
          select(-hpd_area)
      }
      
      #Step 3: shift the off-targetvalues to neg for neg offsets for target_yr observations
      if (input$x_axis_011_eda == "target_year") {
        sim_results_filtered <- sim_results_filtered %>%
          mutate(off_target = if_else(offset_magnitude < 0,
                                      off_target * -1,
                                      off_target))  
      }
      
      #Step 4: Set up colour labs
      colour_lab <- case_when(input$off_target_color_011_eda == 
                                "measurement_error" ~ "Measurement error (1-s)",
                              input$off_target_color_011_eda == 
                                "offset_magnitude" ~ "Offset magnitude (14C yrs)")
      
      #Step 5: Color on demand
      if (input$off_target_color_011_eda == "nope") {
        off_target_plot <- sim_results_filtered %>%
          ggplot(aes(x = !!sym(input$x_axis_011_eda), y = off_target)) +
          geom_point() +
          xlab(x_axis_label) +
          ylab("Off-target magnitude") +
          theme_bw()
      } else {
        off_target_plot <- sim_results_filtered %>%
          ggplot(aes(x = !!sym(input$x_axis_011_eda), y = off_target)) +
          geom_point(aes(col = abs(!!sym(input$off_target_color_011_eda)))) +
          labs(
            x = x_axis_label,
            y = "Off-target magnitude",
            colour = colour_lab
          )
          theme_bw()
      }
      
      
      #Step 6: Remove negatives from the y axis for target-yea x-axis
      
      if (input$x_axis_011_eda == "target_year") {
        off_target_plot +
          scale_y_continuous(labels = c(300, 200, 100,  0, 100, 200, 300),
                             breaks = c(-300, -200, -100,  0, 100, 200, 300),
                             limits = c(-320, 320))
      } else {
        off_target_plot
      }
      
      
    }
    
    
  })
  output$plot_011_heatmap <- renderPlot({
    #Prep labels for figure downstream-------------------------------------------
    x_axis_label_heatmap <- case_when(
      input$x_axis_011_heatmap == "target_year" ~ "Target year (cal BP)",
      input$x_axis_011_heatmap == "measurement_error" ~ "Measurement error (14C yrs)",
      input$x_axis_011_heatmap == "offset_magnitude" ~ "Offset magnitude (14C yrs)"
    )

    y_axis_label_heatmap <- case_when(
      input$y_axis_011_heatmap == "target_year" ~ "Target year (cal BP)",
      input$y_axis_011_heatmap == "measurement_error" ~ "Measurement error (14C yrs)",
      input$y_axis_011_heatmap == "offset_magnitude" ~ "Offset magnitude (14C yrs)"
    )


    #Prep the data frame underpinning the heatmap------------------------------
 
    singles_011_heatmap_df <- singles_011_results %>%
      filter(
        target_year >= input$target_year_011_heatmap[1] &
          target_year <= input$target_year_011_heatmap[2],
        offset_magnitude >= input$offset_magnitude_011_heatmap[1] &
          offset_magnitude <= input$offset_magnitude_011_heatmap[2],
        measurement_error >= input$measurement_error_011_heatmap[1] &
          measurement_error <= input$measurement_error_011_heatmap[2]
      )

    singles_011_heatmap_df <- singles_011_heatmap_df %>%
      #Generate the bins to group on
      mutate(
        target_year  = plyr::round_any(target_year, input$rounding_slider_011_heatmap*100),
        measurement_error = plyr::round_any(measurement_error, input$rounding_slider_011_heatmap),
        offset_magnitude  = plyr::round_any(offset_magnitude, input$rounding_slider_011_heatmap)
      ) %>%
      #Group and summarise (extract average accuracy over a given bin)
      group_by(!!sym(input$x_axis_011_heatmap), !!sym(input$y_axis_011_heatmap)) %>%
      summarise(
        ratio_68 = mean(accuracy_68),
        ratio_95 = mean(accuracy_95)
      ) %>%
      #Pivot to longer and filter
      pivot_longer(c(ratio_68, ratio_95), 
                   names_to = "hpd_area",
                   values_to = "ratio_accurate") %>%
      filter(hpd_area == input$hpd_area_011_heatmap)
    
    colnames(singles_011_heatmap_df)[1] <- "x_axis"
    colnames(singles_011_heatmap_df)[2] <- "y_axis"
    
    singles_011_heatmap_df %>%
      ggplot(aes(x = x_axis, y = y_axis, fill = ratio_accurate)) +
      geom_raster(interpolate = input$interpolate_011_heatmap) +
      theme_minimal() +
      labs(
        x = x_axis_label_heatmap,
        y = x_axis_label_heatmap,
        fill = "Ratio accurate"
      )

  })
  output$plot_011_mpe <- renderPlot({
    
    #Prep sims: filter fit slider choice and round where applicable------------
    sim_results_011_mpe <- singles_011_results %>%
      filter( 
        target_year >= input$target_year_011_mpe[1] & 
          target_year <= input$target_year_011_mpe[2],
        offset_magnitude >= input$offset_magnitude_011_mpe[1] & 
          offset_magnitude <= input$offset_magnitude_011_mpe[2],
        measurement_error >= input$measurement_error_011_mpe[1] & 
          measurement_error <= input$measurement_error_011_mpe[2]
      )
    
    #Get the x_axis_label
    x_axis_label_mpe <- case_when(
      input$x_axis_011_mpe == "target_year" ~ "Target year (cal BP)",
      input$x_axis_011_mpe == "measurement_error" ~ "Measurement error (14C yrs)",
      input$x_axis_011_mpe == "offset_magnitude" ~ "Offset magnitude (14C yrs)"
    )
    
    #Pivot to longer, drop unwanted HPD area, replace NAs with zeros
    
    sim_results_011_mpe <- sim_results_011_mpe %>%
      select(-accuracy_68, -accuracy_95, -precision_68, -precision_95) %>%
      pivot_longer(cols = c(off_target_68, off_target_95),
                   names_to = "hpd_area",
                   values_to = "off_target") %>%
      filter(hpd_area == input$hpd_area_011_mpe) %>%
      mutate(off_target = replace_na(off_target, 0))
    
    #Establish if outside MPE, apply relevant rounding and group
    group_011_mpe <- sim_results_011_mpe %>%
      mutate(
        outside_mpe = if_else(off_target > input$singles_011_say_mpe, 1, 0),
        target_year  = plyr::round_any(target_year, input$rounding_slider_011_mpe*100),
        measurement_error = plyr::round_any(measurement_error, input$rounding_slider_011_mpe),
        offset_magnitude  = plyr::round_any(offset_magnitude, input$rounding_slider_011_mpe)
      ) %>%
      group_by(!!sym(input$x_axis_011_mpe)) %>%
      summarise(
        ratio_out_mpe = mean(outside_mpe)
      )
    
    #Set up the name of the grouped variable for plotting
    colnames(group_011_mpe)[1] <- "x_axis"
    
    group_011_mpe %>%
      ggplot(aes(x = x_axis, y = ratio_out_mpe)) +
      geom_line() +
      labs(
        x = x_axis_label_mpe,
        y = "Ratio outside MPE"
      ) +
      ylim(c(0,1)) +
      theme_bw() +
      geom_hline(yintercept = input$singles_011_tolerance_mpe)
    
    
  })
  
  #WMDs Core plotting----------------------------------------------------------
  output$wmds_eda_hist <- renderPlot({

    # Get the right data
    if (input$wmds_hists_data == "wmds_021") {
      wmds_eda_hist_df <- wmds_021_results
    } else if (input$wmds_hists_data == "wmds_023") {
      wmds_eda_hist_df <- wmds_023_results
    } else if (input$wmds_hists_data == "wmds_024") {
      wmds_eda_hist_df <- wmds_024_results
    } else if (input$wmds_hists_data == "wmds_025") {
      wmds_eda_hist_df <- wmds_025_results
    }
    
    # Filter the data to slider specs and round the data-----------------------
    
    # Adjust targets rounding to the different ranges of targets covered by different data sets
    if (input$wmds_hists_data == "wmds_021") {
      targets_rounding = 100.0
    } else {
      targets_rounding = 10.0
    } 
    
    #Do the filtering and the rounding
    wmds_eda_hist_df <- wmds_eda_hist_df %>%
      filter(
        targets >= input$wmds_hist_hpd_target[1] &
          targets <= input$wmds_hist_hpd_target[2],
        span >= input$wmds_hist_hpd_span[1] &
          span <= input$wmds_hist_hpd_span[2],
        samples >= input$wmds_hist_hpd_samples[1] &
          samples <= input$wmds_hist_hpd_samples[2],
        errors >= input$wmds_hist_hpd_error[1] &
          errors <= input$wmds_hist_hpd_error[2],
        offset >= input$wmds_hist_hpd_offset[1] &
          offset <= input$wmds_hist_hpd_offset[2],
        offset_sd >= input$wmds_hist_hpd_offset_sd[1] &
          offset_sd <= input$wmds_hist_hpd_offset_sd[2]
      ) %>%
      mutate(
        targets  = plyr::round_any(targets, input$wmds_hist_rounding * targets_rounding),
        span = plyr::round_any(span, input$wmds_hist_rounding * 3),
        samples = plyr::round_any(samples, input$wmds_hist_rounding),
        errors = plyr::round_any(errors, input$wmds_hist_rounding),
        offset = plyr::round_any(offset, input$wmds_hist_rounding),
        offset_sd = plyr::round_any(offset_sd, input$wmds_hist_rounding)
      )
    
    #Group the data and evaluate the ratios
    wmds_eda_hist_df <- wmds_eda_hist_df %>%
      group_by(!!sym(input$wmds_hist_x_axis)) %>%
      summarise(
        ratio_68 = mean(accuracy_68),
        ratio_95 = mean(accuracy_95)
      ) %>%
      pivot_longer(
        c(ratio_68, ratio_95),
        names_to = "hpd_area",
        values_to = "ratio_accurate"
      ) %>%
      filter(
        hpd_area == input$wmds_hist_hpd
      )
    
    #Final plotting prep: get relevant bits and pieces to play with ggplot-----
    # Get the x axis
    wmds_hist_x_label <- case_when(
      input$wmds_hist_x_axis == "targets" ~ "Target year (cal BP)",
      input$wmds_hist_x_axis == "span" ~ "Wiggle-match span (cal yrs)",
      input$wmds_hist_x_axis == "samples" ~ "Number of measurements",
      input$wmds_hist_x_axis == "errors" ~ "Measurement error  1-sd (14C yrs)",
      input$wmds_hist_x_axis == "offset" ~ "Mean offset (14C yrs)",
      input$wmds_hist_x_axis == "offset_sd" ~ "Offset standard deviation (14C yrs)"
    )
    
    # rename the x_axis for dynamic plotting
    colnames(wmds_eda_hist_df)[1] <- "x_axis"
    
  
    # Set up the width of bin (wob)
    wmds_hist_round <- as.numeric(input$wmds_hist_rounding)
    wmd_hist_wob <- case_when(
      input$wmds_hist_x_axis == "targets" ~ wmds_hist_round * targets_rounding,
      input$wmds_hist_x_axis == "span" ~ wmds_hist_round * 3,
      TRUE ~ wmds_hist_round
    )

    #Set up the hline
    wmds_hist_hline <- case_when(
      input$wmds_hist_hpd == "ratio_68" ~ 0.682,
      input$wmds_hist_hpd == "ratio_95" ~ 0.954
    )
    
    head(wmds_eda_hist_df)
    

    #Build the ggplot----------------------------------------------------------
    wmds_eda_hist_df %>%
      ggplot(aes(x = x_axis, y = ratio_accurate)) +
      geom_hline(yintercept = wmds_hist_hline) +
      geom_histogram(stat = "identity", width = wmd_hist_wob) +
      ylim(c(0,1)) +
      xlab(wmds_hist_x_label) +
      ylab("Ratio accurate") +
      theme_classic()
  })
  
  
  
})