#Navbar on outer envelope------------------------------------------------------

shinyUI(
  navbarPage(
    title = "14C Sensitivity",
    tabPanel(title = "Home"),
    navbarMenu(title = "Single calibrations",
#Singles011 EDA 1: histograms and off target magnitudes------------------------
               tabPanel(title = "Accuracy histograms and off-target magnitudes",
                        sidebarLayout(
                          sidebarPanel(
                            "",
                            #Select axes---------------------------------------
                            selectInput(
                              inputId = "x_axis_011_eda",
                              label = "Choose variable:",
                              choices = names(singles_011_results[,c(1, 3, 4)])
                            ),
                            radioButtons(
                              inputId = "predicted_variable_011_eda",
                              label = "Choose variable:",
                              choices = list("Accuracy" = "accuracy",
                                             "Off-target" = "off_target")
                            ),
                            radioButtons(
                              inputId = "hpd_area_011_eda",
                              label = "Select HPD Area:",
                              choices = list("68% probability" = "hpd_68",
                                             "95% probability" = "hpd_95")
                            ),
                            #Set up color control for off-target graphs--------
                            radioButtons(
                              inputId = "off_target_color_011_eda",
                              label = "Colour code off-target graph?",
                              choices = list("No" = "nope",
                                             "Measurement error" = "measurement_error",
                                             "Offset magnitude" = "offset_magnitude")
                            ),
                            #Set up the rounding slider------------------------
                            sliderInput(
                              inputId = "rounding_slider_011_eda",
                              label = "Select bin width",
                              min = 1,
                              max = 10,
                              value = 1
                            ),
                            #Set up sliders------------------------------------
                            sliderInput(
                              inputId = "offset_magnitude_011_eda",
                              label = "Offset magnitude (14C yrs)",
                              min = -50,
                              max = 50,
                              value = c(-50, 50)),
                            sliderInput(
                              inputId = "measurement_error_011_eda",
                              label = "Measurement error (14C yrs 1-s)",
                              min = 8,
                              max = 32,
                              value = c(8, 32)
                            ),
                            sliderInput(
                              inputId = "target_year_011_eda",
                              label = "Target year (cal BP)",
                              min = 0, 
                              max = 12310,
                              value = c(0, 12310)
                            )
                            ),
                          #Main panel------------------------------------------
                          mainPanel(
                            plotOutput("plot_011_eda")
                            )
                        )
                        ),
#Singles011 EDA 2: heatmaps----------------------------------------------------
               tabPanel(title = "Heatmaps",
                        sidebarLayout(
                          sidebarPanel(
                            "",
                            #Select axes---------------------------------------
                            selectInput(
                              inputId = "x_axis_011_heatmap",
                              label = "Choose variable:",
                              choices = names(singles_011_results[,c(1, 3, 4)])
                            ),
                            selectInput(
                              inputId = "y_axis_011_heatmap",
                              label = "Choose variable:",
                              choices = names(singles_011_results[,c(1, 3, 4)])
                            ),
                            #Select accuracy level and rounding----------------
                            radioButtons(
                              inputId = "hpd_area_011_heatmap",
                              label = "Select HPD Area:",
                              choices = list("68% probability" = "hpd_68",
                                             "95% probability" = "hpd_95")
                            ),
                            checkboxInput(
                              inputId = "interpolate_011_heatmap",
                              label = "Interpolate heatmap",
                              value = FALSE),
                            sliderInput(
                              inputId = "rounding_slider_011_heatmap",
                              label = "Select bin width",
                              min = 1,
                              max = 10,
                              value = 1
                            ),
                            #Select parameter ranges---------------------------
                            sliderInput(
                              inputId = "offset_magnitude_011_heatmap",
                              label = "Offset magnitude (14C yrs)",
                              min = -50,
                              max = 50,
                              value = c(-50, 50)),
                            sliderInput(
                              inputId = "measurement_error_011_heatmap",
                              label = "Measurement error (14C yrs 1-s)",
                              min = 8,
                              max = 32,
                              value = c(8, 32)
                            ),
                            sliderInput(
                              inputId = "target_year_011_heatmap",
                              label = "Target year (cal BP)",
                              min = 0, 
                              max = 12310,
                              value = c(0, 12310)
                            )
                          ),
                          mainPanel()
                        )),
#Singles011 MPE----------------------------------------------------------------
               tabPanel(title = "Maximum permissable errors",
                        sidebarLayout(
                          sidebarPanel(
                            "",
                            #Select axes---------------------------------------
                          selectInput(
                            inputId = "x_axis_011_mpe",
                            label = "Choose variable:",
                            choices = names(singles_011_results[,c(1, 3, 4)])
                          ),
                          radioButtons(
                            inputId = "hpd_area_011_mpe",
                            label = "Select HPD Area:",
                            choices = list("68% probability" = "off_target_68",
                                           "95% probability" = "off_target_95")
                          ),
                          #MPE controls--------------------------------------
                          sliderInput(
                            inputId = "singles_011_say_mpe",
                            label = "What is your MPE?",
                            min = 0,
                            max = 50,
                            value = 5
                          ),
                          sliderInput(
                            inputId = "singles_011_tolerance_mpe",
                            label = "What is your MPE tolerance?",
                            min = 0,
                            max = 1,
                            value = 0.05
                          ),
                          
                          #Sliders-------------------------------------------
                          sliderInput(
                            inputId = "rounding_slider_011_mpe",
                            label = "Select bin width",
                            min = 1,
                            max = 10,
                            value = 1
                          ),
                          sliderInput(
                            inputId = "offset_magnitude_011_mpe",
                            label = "Offset magnitude (14C yrs)",
                            min = -50,
                            max = 50,
                            value = c(-50, 50)),
                          sliderInput(
                            inputId = "measurement_error_011_mpe",
                            label = "Measurement error (14C yrs 1-s)",
                            min = 8,
                            max = 32,
                            value = c(8, 32)
                          ),
                          sliderInput(
                            inputId = "target_year_011_mpe",
                            label = "Target year (cal BP)",
                            min = 0, 
                            max = 12310,
                            value = c(0, 12310)
                          )
                          ),
                          mainPanel(
                            plotOutput("plot_011_mpe")
                          )
                        )
               ),


#Singles 011 Modelling---------------------------------------------------------
               tabPanel(title = "Modelling")
               ),


#Start WMDs--------------------------------------------------------------------
    navbarMenu(title = "14C wiggle-match dates",
#WMDs EDA I: histograms -------------------------------------------------------            
               tabPanel(title = "Accuracy histograms"),
#WMDs EDA II: off-target magnitudes--------------------------------------------            
               tabPanel(title = "Off-target magnitudes"),
#WMDs EDA III: heatmaps--------------------------------------------------------              
               tabPanel(title = "Heatmaps"),
#WMDs MPE----------------------------------------------------------------------            
               tabPanel(title = "Maximum permissible errors"),
#WMDs Modelling----------------------------------------------------------------              
               tabPanel(title = "Modelling")
               ),





    navbarMenu(title = "Uniform bound sequence models",
#Seqs EDA I: histograms -------------------------------------------------------            
               tabPanel(title = "Accuracy histograms"),
#Seqs EDA II: off-target magnitudes--------------------------------------------            
               tabPanel(title = "Off-target magnitudes"),
#Seqs EDA III: heatmaps--------------------------------------------------------              
               tabPanel(title = "Heatmaps"),
#Seqs MPE----------------------------------------------------------------------            
               tabPanel(title = "Maximum permissible errors"),
#Seqs Modelling----------------------------------------------------------------              
               tabPanel(title = "Modelling")               
               )
    
  )
)