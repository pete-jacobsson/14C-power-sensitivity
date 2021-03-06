#This script covers parsing of OxCal files for the Offset sensitivity project.
#File commented out to avoid risk of overwriting parsed data.
library(tidyverse)
source("003_parsing_tools.R")

# Generate simulation name vectors---------------------------------------------
oxcal_dir <- "C:/Users/Pete.C14/Dropbox/09_OxCal/OxCal01_14CTechnical/201005_SensitivityPaper/"

# wmds_021_names <- str_c(oxcal_dir, "Sensitivity021WMDs/Sensitivity021WMDs", 1:60000)
# wmds_022_names <- str_c(oxcal_dir, "Sensitivity022WMDs/Sensitivity022WMDs", 1:5000)
# wmds_023_names <- str_c(oxcal_dir, "Sensitivity023WMDs/Sensitivity023WMDs", 1:20000)
# wmds_024_names <- str_c(oxcal_dir, "Sensitivity024WMDs/Sensitivity024WMDs", 1:20000)
# wmds_025_names <- str_c(oxcal_dir, "Sensitivity025WMDs/Sensitivity025WMDs", 1:300000)
# seqs_031_names <- str_c(oxcal_dir, "Sensitivity031Seqs/Sensitivity031Seqs", 1:30000)
# seqs_032_names <- str_c(oxcal_dir, "Sensitivity032Seqs/Sensitivity032Seqs", 1:2500)
# seqs_033_names <- str_c(oxcal_dir, "Sensitivity033Seqs/Sensitivity033Seqs", 1:6000)

# Load the simulation parameters-----------------------------------------------
# wmds_021_params <- read_csv("wmds_021_params.csv") %>%
#   mutate(sim_number = SimNumber) %>%
#   select(-X1, - SimNumber)

# wmds_022_params <- read_csv("wmds_022_params.csv") %>%
#   mutate(sim_number = SimNumber,##Add the zero values for the parsing algroithm
#          Offset = 0) %>%
#   select(-X1, - SimNumber)

# wmds_023_params <- read_csv("wmds_023_params.csv") %>%
#   mutate(sim_number = SimNumber) %>%
#   select(-X1, - SimNumber)

# wmds_024_params <- read_csv("wmds_024_params.csv") %>%
#   mutate(sim_number = SimNumber) %>%
#   select(-X1, - SimNumber)

# wmds_025_params <- read_csv("wmds_025_params.csv") %>%
#   mutate(sim_number = SimNumber) %>%
#   select(-X1, - SimNumber)

# seqs_031_params <- read.csv("seqs_031_params.csv") %>%
#  mutate(sim_number = SimNumber) %>%
#  select(-X, - SimNumber)
# 
# seqs_032_params <- read.csv("seqs_032_params.csv") %>%
#  mutate(sim_number = SimNumber,
#         Offset = 0) %>%
#  select(- X1, SimNumber)
# 
# seqs_033_params <- read.csv("seqs_033_params.csv") %>%
#   mutate(sim_number = SimNumber,
#          Offset = 0) %>%
#   select(- X, SimNumber)


# Parse WMDs-------------------------------------------------------------------
# wmds_021_results <- assemble_results(wmds_021_names, wmds_021_params, model_type = "wmd")
# write.csv(wmds_021_results, "wmds_021_results.csv")

# wmds_022_results <- assemble_results(wmds_022_names, wmds_022_params, model_type = "wmd")
# write.csv(wmds_022_results, "wmds_022_results.csv")

# wmds_023_results <- assemble_results(wmds_023_names, wmds_023_params, model_type = "wmd")
# write.csv(wmds_023_results, "wmds_023_results.csv")
# 
# wmds_024_results <- assemble_results(wmds_024_names, wmds_024_params, model_type = "wmd")
# write.csv(wmds_024_results, "wmds_024_results.csv")

# Due to size the parsing of wmds 025 is fragmented into three stages and sub-divided.
# This is to make spotting any issues in the OxCal outputs easy to sort.
# wmds_025_results_100k <- data.frame()
# for (i in 1:100) {
#   bug_spot_100k <- c((((i-1)*1000) +1), (1000*i))
#   wmds_025_results_i <- assemble_results(wmds_025_names[(((i-1)*1000) +1) : (1000*i)],
#                                          wmds_025_params[(((i-1)*1000) +1) : (1000*i),],  ##Adjust for the need to work with new sets of sim numebrs each time
#                                          model_type = "wmd")
#   
#   wmds_025_results_100k <- bind_rows(wmds_025_results_100k, wmds_025_results_i)
# }
# write_csv(wmds_025_results_100k, "wmds_025_results_100k.csv")
# 
# wmds_025_results_200k <- data.frame()
# for (i in 101:200) {
#   bug_spot_200k <- c((((i-1)*1000) +1), (1000*i))
#   wmds_025_results_i <- assemble_results(wmds_025_names[(((i-1)*1000) +1) : (1000*i)],
#                                          wmds_025_params[(((i-1)*1000) +1) : (1000*i),],  ##Adjust for the need to work with new sets of sim numebrs each time
#                                          model_type = "wmd")
#   
#   wmds_025_results_200k <- bind_rows(wmds_025_results_200k, wmds_025_results_i)
# }
# write_csv(wmds_025_results_200k, "wmds_025_results_200k.csv")
# 
# 
# wmds_025_results_300k <- data.frame()
# for (i in 201:300) {
#   bug_spot_300k <- c((((i-1)*1000) +1), (1000*i))
#   wmds_025_results_i <- assemble_results(wmds_025_names[(((i-1)*1000) +1) : (1000*i)],
#                                          wmds_025_params[(((i-1)*1000) +1) : (1000*i),],  ##Adjust for the need to work with new sets of sim numebrs each time
#                                          model_type = "wmd")
#   
#   wmds_025_results_300k <- bind_rows(wmds_025_results_300k, wmds_025_results_i)
# }
# write_csv(wmds_025_results_300k, "wmds_025_results_300k.csv")

#Combine wmds 025 results to form a single DF
# wmds_025_results_100k <- read_csv("wmds_025_results_100k.csv")
# wmds_025_results_200k <- read_csv("wmds_025_results_200k.csv")
# wmds_025_results_300k <- read_csv("wmds_025_results_300k.csv")
# 
# wmds_025_results <- bind_rows(wmds_025_results_100k,
#                               wmds_025_results_200k,
#                               wmds_025_results_300k)
# 
# write_csv(wmds_025_results, "wmds_025_results.csv")

# Parse Uniform Bound Sequences------------------------------------------------
# seqs_031_results <- assemble_results(seqs_031_names, seqs_031_params, model_type = "seq")#A bug somewhere here. Find it.
# write.csv(seqs_031_results, "seqs_031_results.csv")

# seqs_032_results <- assemble_results(seqs_032_names, seqs_032_params, model_type = "seq")#A bug somewhere here. Find it.
# write.csv(seqs_032_results, "seqs_032_results.csv")

# seqs_033_results <- assemble_results(seqs_033_names, seqs_033_params, model_type = "seq")#A bug somewhere here. Find it.
# write.csv(seqs_033_results, "seqs_033_results.csv")

