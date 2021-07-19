####Target - have one iteration samples for each of the simulations in here.
##Check the numbers of sims
library(tidyverse)
source("how_wrong_003_simulation_functions.R")
oxcal_dir <- "C:/Users/Pete.C14/Dropbox/09_OxCal/OxCal01_14CTechnical/201005_SensitivityPaper/"

#wmds021 simulation-------------------------------------------------------
wmds_021_names <- str_c(oxcal_dir, "Sensitivity021WMDs/Sensitivity021WMDs", 1:60000)
wmds_021_params <- read_csv("WMDs021Params.csv")

for(i in 1:1){
  write.table(simulate_wmds(target = wmds_021_params$Targets[i],
                            span = wmds_021_params$Span[i],
                            n_Samples = wmds_021_params$Samples[i],
                            error = wmds_021_params$Errors[i],
                            offset = wmds_021_params$Offset[i],
                            offset_sigma = wmds_021_params$OffsetVaria[i]),
              file = str_c(wmds_021_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal_4_4_1/OxCal/bin/OxCalWin.exe", str_c(wmds_021_names[i], ".input")))
  oxcal_js_stripper(wmds_021_names[i])
}



#wmds022 simulation-------------------------------------------------------
wmds_022_names <- str_c(oxcal_dir, "Sensitivity022WMDs/Sensitivity022WMDs", 1:5000)
wmds_022_params <- read_csv("WMDs022Params.csv")

for(i in 1:5000){
  write.table(simulate_wmds(target = wmds_022_params$Targets[i],
                            span = wmds_022_params$Span[i],
                            n_samples = wmds_022_params$Samples[i],
                            error = wmds_022_params$Errors[i],
                            curve_to_oxcal = "intcal13Real.14c"),
              file = str_c(wmds_022_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal/bin/OxCalWin.exe", str_c(wmds_022_names[i], ".input")))
  strip_oxcal_js(wmds_022_names[i])
}



#wmds023 simulation-------------------------------------------------------
wmds_023_names <- str_c(oxcal_dir, "Sensitivity023WMDs/Sensitivity023WMDs", 1:20000)
wmds_023_params <- read_csv("WMDs023Params.csv")

for(i in 1:1){
  write.table(simulate_wmds(target = wmds_023_params$Targets[i],
                            span = wmds_023_params$Span[i],
                            n_Samples = wmds_023_params$Samples[i],
                            error = wmds_023_params$Errors[i],
                            offset = wmds_023_params$Offset[i],
                            offset_sigma = wmds_023_params$OffsetVaria[i]),
              file = str_c(wmds_023_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal_4_4_1/OxCal/bin/OxCalWin.exe", str_c(wmds_023_names[i], ".input")))
  oxcal_js_stripper(wmds_023_names[i])
}



#wmds024 simulation-------------------------------------------------------
wmds_024_names <- str_c(oxcal_dir, "Sensitivity024WMDs/Sensitivity024WMDs", 1:20000)
wmds_024_params <- read_csv("WMDs024Params.csv")

for(i in 1:1){
  write.table(simulate_wmds(target = wmds_024_params$Targets[i],
                            span = wmds_024_params$Span[i],
                            n_Samples = wmds_024_params$Samples[i],
                            error = wmds_024_params$Errors[i],
                            offset = wmds_024_params$Offset[i],
                            offset_sigma = wmds_024_params$OffsetVaria[i]),
              file = str_c(wmds_024_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal_4_4_1/OxCal/bin/OxCalWin.exe", str_c(wmds_024_names[i], ".input")))
  oxcal_js_stripper(wmds_024_names[i])
}



#wmds025 simulation-------------------------------------------------------
wmds_025_names <- str_c(oxcal_dir, "Sensitivity025WMDs/Sensitivity025WMDs", 1:300000)
wmds_025_params <- read_csv("WMDs025Params.csv")

for(i in 1:1){
  write.table(simulate_wmds(target = wmds_025_params$Targets[i],
                            span = wmds_025_params$Span[i],
                            n_Samples = wmds_025_params$Samples[i],
                            error = wmds_025_params$Errors[i],
                            offset = wmds_025_params$Offset[i],
                            offset_sigma = wmds_025_params$OffsetVaria[i]),
              file = str_c(wmds_025_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal_4_4_1/OxCal/bin/OxCalWin.exe", str_c(wmds_025_names[i], ".input")))
  oxcal_js_stripper(wmds_025_names[i])
}


#seqs031 simulation-------------------------------------------------------
seqs_031_names <- str_c(oxcal_dir, "Sensitivity032Seqs/Sensitivity032Seqs", 1:30000)

seqs_031_params <- read_csv("Seqs032Params.csv")

for (i in 1:1) {
  write.table(simulate_seqs(tsb = seqs_031_params$Targets[i],
                            span = seqs_031_params$Span[i],
                            n_samples = seqs_031_params$Samples[i],
                            error = seqs_031_params$Errors[i],
                            phases = seqs_031_params$Phases[i],
                            offset = seqs_031_params$Offset[i],
                            offset_sigma = seqs_031_params$OffsetVaria[i]
  ),
  file = str_c(seqs_031_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal_4_4_1/OxCal/bin/OxCalWin.exe", str_c(seqs_031_names[i], ".input")))
  strip_oxcal_js(seqs_031_names[i])
}



#seqs032 simulation-------------------------------------------------------

oxcal_dir <- "C:/Users/Pete.C14/Dropbox/09_OxCal/OxCal01_14CTechnical/201005_SensitivityPaper/"
seqs_032_names <- str_c(oxcal_dir, "Sensitivity032Seqs/Sensitivity032Seqs", 1:2500)

seqs_032_params <- read_csv("Seqs032Params.csv")

for (i in 1:1) {
  write.table(simulate_seqs(tsb = seqs_032_params$Targets[i],
                            span = seqs_032_params$Span[i],
                            n_samples = seqs_032_params$Samples[i],
                            error = seqs_032_params$Errors[i],
                            phases = seqs_032_params$Phases[i],
                            offset = 0,
                            offset_sigma = seqs_032_params$OffsetVaria[i],
                            curve_to_oxcal = "intcal13Real.14c"
                            ),
              file = str_c(seqs_032_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal/bin/OxCalWin.exe", str_c(seqs_032_names[i], ".input")))
  strip_oxcal_js(seqs_032_names[i])
}



#seqs033 simulation-------------------------------------------------------

oxcal_dir <- "C:/Users/Pete.C14/Dropbox/09_OxCal/OxCal01_14CTechnical/201005_SensitivityPaper/"
seqs_033_names <- str_c(oxcal_dir, "Sensitivity033Seqs/Sensitivity033Seqs", 1:6000)

seqs_033_params <- read_csv("Seqs033Params.csv")

for (i in 1:1) {
  write.table(simulate_seqs(tsb = seqs_033_params$Targets[i],
                            span = seqs_033_params$Span[i],
                            n_samples = seqs_033_params$Samples[i],
                            error = seqs_033_params$Errors[i],
                            phases = 1,
                            offset = 0,
                            offset_sigma = seqs_033_params$OffsetVaria[i]
  ),
  file = str_c(seqs_033_names[i], ".input"), row.names = F, quote = F)
  system(paste("C:/Users/Pete.C14/Progs/OxCal_4_4_1/OxCal/bin/OxCalWin.exe", str_c(seqs_033_names[i], ".input")))
  strip_oxcal_js(seqs_033_names[i])
}
