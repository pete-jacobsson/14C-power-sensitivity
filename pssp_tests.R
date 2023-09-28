library(tidyverse)

pssp::plot_simulation_results_osc(range_to_plot = c(10, 15), hpd_area = "accuracy_68",
                                  variable = "curve_uncert", rounding = 5,
                                  xlab = "Calibration curve uncertainty",
                                  singles_results_csv = "single_cals_w_curve_uncert.csv")
