#This file contains simulation functions that produce OxCal input

#Set up-----------------------------------------------------------------------------
library(tidyverse)
intcal_20 <- read_csv("IntCal20Interpolated.csv")

#select_dates--------------------------------------------------------------------- 
#A support function enabling date selection in automated generation of WMDs

select_dates <- function(target, span, n_samples) {
  #Takes in information on the target date, the span to be covered by the sim WMD and the number of Samples
  #Returns a vector of target dates for the wiggle-match
  #Assumes Span >= NSamples and all inputs should be integers

  #Original function used in project - produces symmetric distribution of simulation dates.
  #See below for a faster (and more obvious) function recommened for future application

  wmd_dates <- target

  for (i in 1:(n_samples-2)) {
    wmd_dates <- c(wmd_dates, wmd_dates[i] + (span/(n_samples-1)))
  }

  wmd_dates <- c(wmd_dates, target+span-1)
  wmd_dates <- floor(wmd_dates)
  wmd_dates

}

# select_dates <- function(target, span, n_samples) {
#   wmd_dates <- seq(from = target, to = target + span -1, length.out = n_samples)
#   wmd_dates <- floor(wmd_dates)
#   wmd_dates
# } #a much simpler alternative, though fails to pra symmetric selection


#simulate_wmds---------------------------------------------
#This function:
#simulates aseries of 14C measurements consistent with specification
#prints then to a format consistent with OxCal D_Sequence() function

simulate_wmds <- function(target, 
                           span, 
                           n_samples, 
                           error, 
                           offset = 0, offset_sigma =0, 
                           curve_to_oxcal = NA, 
                           cal_curve = intcal_20
                           ) {
  #The function takes in a series of parameters specifying:
  #wiggle-match target date, structure, offsets and calibration curve
  #The function returns a data frame that is consistent with OxCal input formatting
  #Function assumes that n_samples !> span, n_samples>=2 and that oxcal will recognize the calibration curve
  #span and n_samples need to be integers
  
  #Select target dates.
  if(n_samples == 2){sims_dates <- c(target, target+span-1)}else{
    sims_dates <- select_dates(target, span, n_samples)}##Use the Date Selector function to get the right cal BP values for the WMD
  
  #Extract the gaps between the measurements
  gaps <- rev(sims_dates[2:n_samples] - sims_dates[1:(n_samples-1)])
  
  sims_dates <- cal_curve[cal_curve$CalBP %in% sims_dates,]##Expand from cal BP Dates to All relevant data
  
  sims_ages <- rnorm(n_samples, sims_dates$BP, error) + offset ## Get the 14C Ages 
  sims_ages <- rnorm(n_samples, sims_ages, offset_sigma)
  sims_ages <- rev(sims_ages) # Consider piping in revision
  
  sims_ages
  
  if (is.na(curve_to_oxcal)) {
    open_wm <- paste(c('Plot(){D_Sequence( T', target, '){R_Date('), 
                     collapse="")} else {
      open_wm <- paste(c('Options(){Curve = "', curve_to_oxcal  ,'";};Plot(){D_Sequence( T', target, '){R_Date('), 
                       collapse="") 
    } #In a future revision consider replacing with str_c()
  commands <- c(open_wm, rep("R_Date(", n_samples-1))
  closing_statement <- c()
  for(i in 1:(n_samples-1)){
    closing_statement <- c(closing_statement,paste(c(",", error,");Gap(", gaps[i],");"), 
                                                collapse = ""))} #definite vectorization candidate
  close_wm <- paste(c(",", error,");};};"), collapse="")
  closing <- c(closing_statement, close_wm)
  
  oxcal_input <- data.frame(commands, sims_ages, closing)
  names(oxcal_input) = NULL
  rownames(oxcal_input) = NULL
  oxcal_input
  
  
  
    
}

#Sample usage
simulate_wmds(250, 30, 10, 20)



#simulate_seqs-----------------------------------------------------------
#This function takes on a series of arguments to produce 
#a series of simulated 14C measurements printed into a model scripts consistent with oxcal's Sequence() model



simulate_seqs = function(tsb,                              #start date for the simulated sequence
                         span,                             #span of the simulated sequence
                         n_samples,                        #number of simulated measurements
                         phases,                           #number of phases within the simulated sequence
                         error,                            #simulated measurement error
                         offset = 0, offset_sigma = 0,     #simulated systematic offset and standard deviation of that offset
                         curve_to_oxcal = NA,              #specify curve for oxcal
                         cal_curve = intcal_20){            #specify from which curve to simulate
  
  teb <- tsb - span                                        #define sequence end boundary
  curve <- subset(cal_curve, CalBP >= teb &  CalBP <= tsb)
  
  sim_dates <- sample(curve$CalBP, n_samples, replace = TRUE)
  curve <- curve[curve$CalBP %in% sim_dates,]               #here we select the calibration curve values that will be used in the simulation
  sim_ages <- rep(NA, n_samples)
  for (i in 1:length(sim_dates)) {
    sim_ages[i] <- rnorm(1, 
                         curve[curve$CalBP %in% sim_dates[i],]$BP, 
                         error) + 
      offset
    sim_ages[i] <- rnorm(1, 
                         sim_ages[i], 
                         offset_sigma)
  }                                                         #run the 14C simulation. Consider vectorizing. Consider building offset randomization into a single line.
  sims_df <- data.frame(sim_dates, sim_ages)
  sims_df <- sims_df[rev(order(sims_df$sim_dates)),]        #assemble into data frame and re-arrange to older first (consistent with oxcal)
  
  phases_df <- data.frame(phase_number = seq(1, phases), 
                          sims_in_phase = rep(1, phases)) ## Set up DF tracking how many sims per each phase
  
  if (n_samples > phases) {
    for (i in 1:(n_samples - phases)) {
      to_add <- sample(phases, 1)
      phases_df$sims_in_phase[to_add] <- phases_df$sims_in_phase[to_add] + 1
    }
  }                                                         #distribute the number of measurements across multiple phases. Consider developing a vectorized approach.
  
  sims_cumulative <- c(phases_df$sims_in_phase[1])
  if (phases > 1) {
    for (i in 2:phases) {
      sims_cumulative <- c(sims_cumulative, 
                          sims_cumulative[i-1] + phases_df$sims_in_phase[i])
    }
  }
  
  phases_df <- cbind(phases_df, 
                    sim_phase_start = sims_cumulative - phases_df$sims_in_phase + 1,
                    sims_cumulative)                       #thus bringing together a DF saying how many samples per phase and cumulative numbers
  

  
  oxcal_input <- data.frame()
  for (i in 1:phases) {
    commands <- c('Phase(){R_Date(', 
                 rep('R_Date(', phases_df$sims_in_phase[i]-1))
    sim_ages <- sims_df$sim_ages[phases_df$sim_phase_start[i] : 
                                  phases_df$sims_cumulative[i]]
    closing_statement <- c(rep(paste(c(',', error, ');'), collapse = ""), phases_df$sims_in_phase[i]-1), 
                         paste(c(',', error, ');};'), collapse = ""))
    add_to_input <- data.frame(commands, sim_ages, closing_statement)
    oxcal_input <- rbind(oxcal_input, add_to_input)
  }                                                        #this sets up a df with all the phases in order, OxCal readable. 
                                                           #Uses a phase-by-phase approach.
                                                           #If possible, simplify.
  
  if (is.na(curve_to_oxcal)) {
    opening_commands <- paste(c('Plot(){Sequence(){Boundary("TSB', tsb, '");'), collapse = "")
  } else {
    opening_commands <- paste(c('Options(){Curve = "', curve_to_oxcal  ,
                               '";};Plot(){Sequence(){Boundary("TSB', tsb, '");'), collapse = "")
  }                                                       #this gets the opening commands for model script allowing for varying the calibration curve used
  
  closing_statement <- paste(c('Boundary("TEB', teb, '");};};'))   #this gets the closing commands for model script
  
  oxcal_input$commands <- as.character(oxcal_input$commands)
  oxcal_input$closing_statement <- as.character(oxcal_input$closing_statement)  #de-factorize
  
  oxcal_input[1,1] <-  paste(c(opening_commands, oxcal_input[1,1]), collapse = "")
  oxcal_input[n_samples, 3] <- paste(c(oxcal_input[n_samples, 3], closing_statement), collapse = "")  ##Add the Model opening and ending
  
  names(oxcal_input) = NULL
  rownames(oxcal_input) = NULL
  
  oxcal_input
}

#sample usage
simulate_seqs(2500, 30, 20, 2, 20)

#strip_oxcal_js---------------------------------------------------------------------
#A function that removes the calibration curve data from the oxcal js file, saves it as a .txt file and then deletes all other oxcal output files
#This saves disk space for large numbers of simulations

strip_oxcal_js <- function(oxcal_name) {
  # This function removes the calibration data from the oxcal file removes the .js file and writes a new output file
  # Assume: passed a vector of relevant paths
  js_name <- str_c(oxcal_name, ".js")
  input_name <- str_c(oxcal_name, ".input")
  log_name <- str_c(oxcal_name, ".log")
  stripped_name <- str_c(oxcal_name, ".txt")
  
  oxcal_output <- scan(js_name, character(0), sep = "\n", quiet = T, strip.white = T)
  oxcal_output <- oxcal_output[!str_detect(oxcal_output, "calib")]
  write_lines(oxcal_output, stripped_name)
  sapply(c(js_name, input_name, log_name), unlink)
}
