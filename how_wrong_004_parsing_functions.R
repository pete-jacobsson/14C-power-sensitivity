#This file contains parsing functions that work with oxCal output files.
library(tidyverse)

#detect_oxcal_warning-----------------------------------
detect_oxcal_warning <- function(oxcal_output) {
  #This function provides a TRUE/FALSE answer to whether the OxCal output contains any:
  #ZERO distribution warnings, or uncalculated HPD Areas.
  #The function assumes that the warnings in the input file are consistent with OxCal output style
  zero_warning_check <- str_detect(oxcal_output, "Warning! ZERO distribution") %>%
    sum()
  range_warning_check <- str_detect(oxcal_output, "Warning! Not calculating range") %>%
    sum()
  resolve_warning_check <- str_detect(oxcal_output, "Warning! Cannot resolve order") %>%
    sum()
  incomplete_range_check <- str_detect(oxcal_output, "\\.\\.\\.") %>%
    sum()
  warning_check <- FALSE
  if (incomplete_range_check !=0) {warning_check <- TRUE}
  if (zero_warning_check !=0) {warning_check <- TRUE}
  if (range_warning_check !=0) {warning_check <- TRUE}
  if (resolve_warning_check !=0) {warning_check <- TRUE} #Make alphabetic
  
  warning_check
}




#read_oxcal_name----------------------------
read_oxcal_name <- function(oxcal_output, search_index = '="T') {
  # Function extracts names of indexed parameters from an oxcal .js file
  # Function assumes that search indices are unique and that the oxcal output is presented as a vector of strings
  
  # First extract the ocd index that marks where the information is held
  oxcal_ocd_index <- oxcal_output[str_detect(oxcal_output, search_index)] %>%
    str_extract("ocd\\[\\d+\\]") %>%
    parse_number() %>%
    unique()
  
  # Now extract the target full names as strings
  oxcal_target_names_regex <- str_c("ocd\\[", oxcal_ocd_index, "\\]\\.\\w+\\.comment\\[0\\]")
  
  ## Inbuilt flexibility to allow for both .likelihoods and .posteriors to be scanned
  oxcal_target_names <- NULL
  for (rgx in oxcal_target_names_regex) {
    oxcal_target_names <- c(
      oxcal_target_names,
      oxcal_output[str_detect(oxcal_output, rgx)] %>%
        str_extract(paste( # use paste for flexibility
          str_extract(search_index, "\\w+"), # extract the first part of the target name
          "\\w*",
          sep = ""
        )) %>%
        unique()
    ) # extract the actual target string
  }
  
  oxcal_target_names <- data.frame(search_index = oxcal_ocd_index, oxcal_target_names)
  oxcal_target_names
}

#agreement readers-----------------------------------
detect_agreement <- function(oxcal_output) {
  #Function checks whether the OxCal model has produced an agreement index
  #Assumes that input provided is a string
  wmd_detect <- str_detect(oxcal_output, "Acomb")
  seq_detect <- str_detect(oxcal_output, "modelAgreement")
  
  if (sum(wmd_detect, seq_detect) == 0) {
    agreement_present <- FALSE} else {agreement_present <- TRUE}
  
  agreement_present
  }



read_wmd_agreement <- function(oxcal_output, full_output = FALSE, sim_number = NA) {
  # Function extracts the agreement of a WMD, either as:
  # a 0/1 pass/fail, or providing Aoverall, An and a pass/fail indicator
  # Function requires a vector of character strings as an input, consistent with oxcal .js output format for wmd results
  # Function designed to only process one WMD at a time (it is not vectorized)
  warning_check <- detect_oxcal_warning(oxcal_output)  # Can pass the warning check into a modularized function
  if (warning_check == TRUE) {
    oxcal_names <- read_oxcal_name(oxcal_output)
    oxcal_agreement <- data.frame(oxcal_names) %>%
      mutate(a_pass = FALSE) %>%
      select(-search_index)
    
    if (full_output == TRUE) {
      oxcal_agreement <- oxcal_agreement %>%
        mutate(
          agreement_overall = 0,
          agreement_n = 0
        )
    }
    
    if (!is.na(sim_number)) {
      oxcal_agreement <- oxcal_agreement %>%
        mutate(sim_number = sim_number)
    }
    
    return(oxcal_agreement)
    
  }
  
  
  check_agreement <- detect_agreement(oxcal_output)
  if (check_agreement == FALSE) {
    agreement_overall <- 0
    agreement_n <- 60
  } else {
    agreement_overall <- str_extract(oxcal_output, "Acomb=(\\s*\\d+\\.\\d+)") %>%
      parse_number() %>%
      mean(na.rm = TRUE)
    agreement_n <- str_extract(oxcal_output, "An=(\\s*\\d+\\.\\d+)") %>%
      parse_number() %>%
      mean(na.rm = TRUE)
  }
  
  if (agreement_overall >= agreement_n) {
    a_pass <- "Pass"
  } else {
    a_pass <- "Fail"
  }
  
  oxcal_names <- read_oxcal_name(oxcal_output)
  
  oxcal_agreement <- data.frame(oxcal_names) %>%
    mutate(a_pass = a_pass) %>%
    select(-search_index)
  
  if (full_output == TRUE) {
    oxcal_agreement <- oxcal_agreement %>%
      mutate(
        agreement_overall = agreement_overall,
        agreement_n = agreement_n
      )
  }
  
  if (!is.na(sim_number)) {
    oxcal_agreement <- oxcal_agreement %>%
      mutate(sim_number = sim_number)
  }
  
  oxcal_agreement
}

read_seq_agreement <- function(oxcal_output, sim_number = NA) {
  # Function reads the agreement of an OxCal Sequence() type model.
  # Assumes the input provided is consistent with the style of oxcal outputs.
  warning_check <- detect_oxcal_warning(oxcal_output)
  if (warning_check == TRUE) {
    oxcal_names <- read_oxcal_name(oxcal_output)
    oxcal_agreement <- data.frame(oxcal_names) %>%
      mutate(agreement_model = 0) %>%
      select(-search_index)
    
    if (!is.na(sim_number)) {
      oxcal_agreement <- oxcal_agreement %>%
        mutate(sim_number = sim_number)
    }
    
    return(oxcal_agreement)
    
  }
  
  check_agreement <- detect_agreement(oxcal_output)
  if (check_agreement == FALSE) {
    agreement_model <- 0
  } else {
  agreement_model <- str_extract(oxcal_output, "modelAgreement=(\\s*\\d+\\.\\d)") %>%
    parse_number() %>%
    mean(na.rm = TRUE)
  }
  oxcal_names <- read_oxcal_name(oxcal_output)
  
  
  oxcal_agreement <- oxcal_names %>%
    mutate(
      agreement_model = agreement_model
    ) %>%
    select(-search_index)
  
  
  if (!is.na(sim_number)) {
    oxcal_agreement <- oxcal_agreement %>%
      mutate(sim_number = sim_number)
  }
  
  
  oxcal_agreement
}


#read_oxcal_hpd-------------------------------------------------
read_oxcal_hpd <- function(oxcal_output, search_index = '="T', sim_number = NA) {
  # Function extracts 68.2% and 95.4% HPD Areas of indexed parameters from an oxcal .js file
  # Function output: sim_number (optional), param_name, high_68, low_68, prob_68, high_95, low_95, prob_95, model_run
  # Function assumes that search indices are unique and that the oxcal output is presented as a vector of strings
  
  # Run the zero warning check--------------------------------------------------------------
  oxcal_warning <- detect_oxcal_warning(oxcal_output) 
  if (oxcal_warning == TRUE) {
    oxcal_target_names <- read_oxcal_name(oxcal_output, search_index = search_index)$oxcal_target_names
    model_not_run <- tibble( #Consider taking the model not run tibble out of the brackets to cut the code downstream
      high_68 = rep(NA, length(oxcal_target_names)),
      low_68 = rep(NA, length(oxcal_target_names)),
      prob_68 = rep(NA, length(oxcal_target_names)),
      high_95 = rep(NA, length(oxcal_target_names)),
      low_95 = rep(NA, length(oxcal_target_names)),
      prob_95 = rep(NA, length(oxcal_target_names)),
      oxcal_target_names = oxcal_target_names,
      model_run = rep(0, length(oxcal_target_names))
    )
    
    if (!is.na(sim_number)) {
      model_not_run <- model_not_run %>%
        mutate(sim_number = sim_number)
    }
    
    return(model_not_run)
  }
  
  # First extract the ocd index that marks where the information is held------------------
  oxcal_ocd_index <- oxcal_output[str_detect(oxcal_output, search_index)] %>%
    str_extract("ocd\\[\\d+\\]") %>%
    parse_number() %>%
    unique()
  
  
  # Second: set up and regex out the strings with the hpd data----------------------------
  oxcal_hpd_regex <- str_c("ocd\\[", oxcal_ocd_index, "\\]\\.\\w+\\.range\\[[12]\\]\\[\\d+")
  
  oxcal_hpd_strings <- NULL
  for (rgx in oxcal_hpd_regex) {
    oxcal_hpd_strings <- c(
      oxcal_hpd_strings,
      oxcal_output[str_detect(oxcal_output, rgx)]
    )
  } ## This section gets the particular strings containing the HPD ranges
  
  
  # Third: Parse out the numbers from the strings----------------------------------------
  # Working on: oxcal_strings_split:
  # this df is used in processing from the vector of extracted strings to a df with numerical values
  hpd_output_tags <- data.frame(
    tag = rep(
      c("ocd", "search_index", "hpd_area", "instance", "high", "low", "prob"),
      length(oxcal_hpd_strings)
    ), # names elements of the output vector
    output_line = sort(rep(seq(from = 1, to = length(oxcal_hpd_strings)), 7))
  ) # indexes which string was parsed
  
  oxcal_strings_split <- oxcal_hpd_strings %>% # breaks up the strings to enable the use of parse_number
    str_split("[,\\[]") %>% # break up the string to be able to use parse number
    lapply(as.data.frame) %>% # converts the list of strings into a list of single column dfs
    bind_rows() %>% # binds the single column dfs
    bind_cols(hpd_output_tags) %>% # Attaches the tags
    filter(tag != "ocd" & tag != "instance")
  
  colnames(oxcal_strings_split) <- c("result", "tag", "return") # chabge the column names
  
  oxcal_strings_split <- oxcal_strings_split %>% # parse numbers out
    mutate(
      result = parse_number(result)
    )
  
  #Check that both HPD areas are calculated (refer to WMDs025 sim 19807)
  are_hpds_calculated <- oxcal_strings_split %>%
    filter(tag == "hpd_area") %>%
    pull(result) %>%
    unique()
  
  are_hpds_calculated <- sum(are_hpds_calculated %in% c(1,2))
  
  if (are_hpds_calculated != 2) {
    oxcal_target_names <- read_oxcal_name(oxcal_output, search_index = search_index)$oxcal_target_names
    model_not_run <- tibble(
      high_68 = rep(NA, length(oxcal_target_names)),
      low_68 = rep(NA, length(oxcal_target_names)),
      prob_68 = rep(NA, length(oxcal_target_names)),
      high_95 = rep(NA, length(oxcal_target_names)),
      low_95 = rep(NA, length(oxcal_target_names)),
      prob_95 = rep(NA, length(oxcal_target_names)),
      oxcal_target_names = oxcal_target_names,
      model_run = rep(0, length(oxcal_target_names))
    )
    
    if (!is.na(sim_number)) {
      model_not_run <- model_not_run %>%
        mutate(sim_number = sim_number)
    }
    
    return(model_not_run)
  }
  
  
  # Fourth: extract numbers and prepare for table re-formatting------------------------
  # Working with: oxcal_hpd_numbers - takes the table of numbers from oxcal_strings_split and reformats it to function spec.
  oxcal_hpd_numbers <- oxcal_strings_split
  colnames(oxcal_hpd_numbers) <- c("result", "tag", "return") # chabge the column names
  
  oxcal_hpd_numbers <- oxcal_hpd_numbers %>% # parse numbers out
    pivot_wider(names_from = tag, values_from = result) %>% # to wider
    select(-return) %>%
    mutate(hpd_area = if_else(hpd_area == 1, "68", "95"))
  
  
  
  oxcal_hpd_numbers <- oxcal_hpd_numbers %>%
    # re-format the table to wider still
    pivot_longer(cols = c(high, low, prob)) %>%
    mutate(hpd_area = str_c(name, "_", hpd_area)) %>%
    select(-name) %>%
    pivot_wider(names_from = hpd_area, values_from = value)
  
  
  # Fifth re-formatting the table towards final shape-------------------------------
  
  oxcal_hpd_df <- NULL
  for (i in 1:length(oxcal_hpd_numbers$search_index)) { # This cycles through search indices to avoid running into issues at re-joining tables with multiple names
    result_worked_on <- oxcal_hpd_numbers %>% # Work on one results (marked by a single index) at a time
      filter(search_index == search_index[i])
    
    result_worked_on_68 <- result_worked_on %>%
      # break up into two tables for unnesting
      select(search_index, high_68, low_68, prob_68) %>%
      unnest(cols = c("high_68", "low_68", "prob_68")) %>%
      mutate(row_n = seq(1:length(search_index))) # set up row number as a temporary variable for re-joining
    result_worked_on_95 <- result_worked_on %>%
      select(search_index, high_95, low_95, prob_95) %>%
      unnest(cols = c("high_95", "low_95", "prob_95")) %>%
      mutate(row_n = seq(1:length(search_index)))
    
    oxcal_hpd_df <- rbind(
      oxcal_hpd_df,
      full_join(result_worked_on_68, result_worked_on_95)
    )
  }
  
  oxcal_hpd_df <- oxcal_hpd_df %>%
    select(-row_n)
  
  oxcal_names <- read_oxcal_name(oxcal_output, search_index = search_index)
  
  oxcal_hpd_df <- oxcal_hpd_df %>%
    inner_join(oxcal_names, by = "search_index") %>%
    mutate(
      model_run = 1
    ) %>%
    select(-search_index)
  
  if (!is.na(sim_number)) {
    oxcal_hpd_df <- oxcal_hpd_df %>%
      mutate(
        sim_number = sim_number
      )
  }
  
  oxcal_hpd_df
}


#assemble_raw_results------------------------------
assemble_raw_results <- function(oxcal_outputs, full_name = FALSE) {
  # This function puts together the long tables of raw oxcal results from across multiple oxcal models
  # Assumes that oxcal file names are passed as strings
  if (full_name == FALSE) {
    oxcal_outputs <- str_c(oxcal_outputs, ".txt")
  }
  
  raw_results <- NULL
  for (i in 1:length(oxcal_outputs)) {
    current_output <- read_lines(oxcal_outputs[i])
    raw_results <- rbind(
      raw_results,
      read_oxcal_hpd(
        oxcal_output = current_output,
        sim_number = i
      )
    )
  }
  
  raw_results
}






#process_raw_results-------------------------------------------------------------------
process_raw_results <- function(raw_results) {
  # This function starts with the assemble outputs and:
  # a) convert dates to cal BP;
  # b) extracts target dates;
  # c) calculates accuracy
  # d) estimates precision
  # It assumes that the target dates are built into target names and
  # that the raw_results table is consistent with outputs of all the preceding steps
  
  evaluated_results <- raw_results %>%
    mutate(
      high_68 = 1950 - high_68,
      low_68 = 1950 - low_68,
      high_95 = 1950 - high_95,
      low_95 = 1950 - low_95,
      target_date = parse_number(oxcal_target_names),
      target_parameter_id = str_c(sim_number, oxcal_target_names) # This ensures uniqueness for grouping purposes further down the line
    ) %>%
    mutate(
      accuracy_68 = if_else(target_date <= high_68 & target_date >= low_68, 1, 0),
      accuracy_95 = if_else(target_date <= high_95 & target_date >= low_95, 1, 0),
      precision_68 = high_68 - low_68,
      precision_95 = high_95 - low_95,
      # Use a case when approach to deterimine individual off-target magnitudes. Then in the next step choose smallest.
      off_target_68 = case_when(
        target_date <= high_68 & target_date >= low_68 ~ 0,
        target_date >= high_68 ~ abs(target_date - high_68),
        target_date <= low_68 ~ abs(target_date - low_68),
        model_run == 0 ~ 0
      ),
      off_target_95 = case_when(
        target_date <= high_95 & target_date >= low_95 ~ 0,
        target_date >= high_95 ~ abs(target_date - high_95),
        target_date <= low_95 ~ abs(target_date - low_95),
        model_run == 0 ~ 0
      )
    )
  
  evaluated_results
}



#assemble_agreement-------------------------
assemble_agreement <- function (oxcal_outputs, model_type, full_name = FALSE) {
  # This function takes in a vector of strings with oxcal output names and returns
  # a data frame with simulation number and agreement values
  # Assumes the set of strings passed links to oxcal outputs
  if (full_name == FALSE) {
    oxcal_outputs <- str_c(oxcal_outputs, ".txt")
  }
  
  oxcal_agreements <- NULL
  if (model_type == "wmd") {
    for (i in 1:length(oxcal_outputs)) {
      current_output <- read_lines(oxcal_outputs[i])
      oxcal_agreements <- rbind(oxcal_agreements,
                                read_wmd_agreement(oxcal_output = current_output,
                                                   sim_number = i))
    }
    oxcal_agreements <- oxcal_agreements %>%
      select(-oxcal_target_names)
  } else {
    for (i in 1:length(oxcal_outputs)) {
      current_output <- read_lines(oxcal_outputs[i])
      oxcal_agreements <- rbind(oxcal_agreements,
                                read_seq_agreement(oxcal_output = current_output,
                                                   sim_number = i))
    }
    oxcal_agreements <- oxcal_agreements %>%
      group_by(sim_number) %>%
      summarize(
        agreement_model = min(agreement_model)
      )
  }
  
  oxcal_agreements
  
  
}

#assemble_results---------------------------
#This function uses grouping and summarize() to:
#Evaluate whether the 68% ranges contain the target date
#Evaluate the total precisiona cross all ranges
#Planned integration - include adjusted precision

assemble_results <- function(oxcal_outputs, model_type, params, 
                             full_name = FALSE, flexible_sim = TRUE) {
  raw_results <- assemble_raw_results(oxcal_outputs, full_name = full_name)
  processed_results <- process_raw_results(raw_results)
  
  if (flexible_sim == TRUE) { 
    params$sim_number <- seq(from = 1, to = nrow(params), by = 1)
  }#Allows for the possibility that the parsing needs to be broken down into smaller components.
   #Note reduced cross-verification.
  
  assembled_results <- processed_results %>%
    group_by(target_parameter_id) %>%
    summarize(
      sim_number = min(sim_number),
      oxcal_target = sample(oxcal_target_names, 1),
      accuracy_68 = sum(accuracy_68, na.rm = TRUE),
      accuracy_95 = sum(accuracy_95, na.rm = TRUE),
      precision_68 = sum(precision_68, na.rm = TRUE),
      precision_95 = sum(precision_95, na.rm = TRUE),
      off_target_68 = min(off_target_68, na.rm = TRUE),
      off_target_95 = min(off_target_95, na.rm = TRUE),
      model_run = min(model_run, na.rm = TRUE)
    ) %>%
    arrange(sim_number)
  
  assembled_results <- assembled_results %>%
    select(-target_parameter_id)
  
  oxcal_agreements <- assemble_agreement(oxcal_outputs, model_type = model_type, full_name = full_name)
  
  
  assembled_results <- inner_join(assembled_results, oxcal_agreements)
  assembled_results <- inner_join(assembled_results, params)
  # oxcal_agreements
  assembled_results <- assembled_results %>%
    relocate(model_run,
             accuracy_68,
             accuracy_95,
             precision_68,
             precision_95,
             off_target_68,
             off_target_95,
             .after = OffsetVaria
    )
  
  
  assembled_results
}