#Navbar on outer envelope------------------------------------------------------

shinyUI(
  navbarPage(
    title = "14C Sensitivity",
    tabPanel(title = "Home"),
    navbarMenu(title = "EDA",
#Singles011 EDA----------------------------------------------------------------
               tabPanel(title = "Single Calibrations 011",
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
#WMDs021 EDA-------------------------------------------------------------------
               tabPanel(title = "Wiggle-match Dates 021"),
#WMDs023 EDA-------------------------------------------------------------------
               tabPanel(title = "Wiggle-match Dates 023"),
#WMDs024 EDA-------------------------------------------------------------------
               tabPanel(title = "Wiggle-match Dates 024"),
#WMDs025 EDA-------------------------------------------------------------------
               tabPanel(title = "Wiggle-match Dates 025"),
#Seqs031 EDA-------------------------------------------------------------------
               tabPanel(title = "Uniform Bound Sequences 031"),
#Seqs033 EDA-------------------------------------------------------------------
               tabPanel(title = "Uniform Bound Sequences 033")
               ),



    navbarMenu(title = "Maximum Permissible Error",
#Singles011 MPE----------------------------------------------------------------               
               tabPanel(title = "Single Calibrations 011",
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
#WMDs021 EDA-------------------------------------------------------------------              
               tabPanel(title = "Wiggle match Dates 021"),
#WMDs022 EDA-------------------------------------------------------------------              
               tabPanel(title = "Wiggle match Dates 022"),
#WMDs023 EDA-------------------------------------------------------------------               
               tabPanel(title = "Wiggle match Dates 023"),
#WMDs024 EDA-------------------------------------------------------------------              
               tabPanel(title = "Wiggle match Dates 024"),
#WMDs025 EDA-------------------------------------------------------------------               
               tabPanel(title = "Wiggle match Dates 025"),
#Seqs031 EDA-------------------------------------------------------------------               
               tabPanel(title = "Uniform Bound Sequences 031"),
#Seqs032 EDA-------------------------------------------------------------------                 
               tabPanel(title = "Uniform Bound Sequences 032"),
#Seqs033 EDA-------------------------------------------------------------------                 
               tabPanel(title = "Uniform Bound Sequences 033")
               ),





    navbarMenu(title = "Modelling")
    
  )
)