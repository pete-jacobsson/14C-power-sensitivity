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
                              inputId = "x_axis_011",
                              label = "Choose variable:",
                              choices = names(singles_011_results[,c(1, 3, 4)])
                            ),
                            radioButtons(
                              inputId = "predicted_variable_011",
                              label = "Choose variable:",
                              choices = list("Accuracy" = "accuracy",
                                             "Off-target" = "off_target")
                            ),
                            radioButtons(
                              inputId = "hpd_area_011",
                              label = "Select HPD Area:",
                              choices = list("68% probability" = "hpd_68",
                                             "95% probability" = "hpd_95")
                            ),
                            #Set up color control for off-target graphs--------
                            radioButtons(
                              inputId = "off_target_color",
                              label = "Colour code off-target graph?",
                              choices = list("No" = "nope",
                                             "Measurement error" = "measurement_error",
                                             "Offset magnitude" = "offset_magnitude")
                            ),
                            #Set up the rounding slider------------------------
                            sliderInput(
                              inputId = "rounding_slider",
                              label = "Select bin width",
                              min = 1,
                              max = 10,
                              value = 1
                            ),
                            #Set up sliders------------------------------------
                            sliderInput(
                              inputId = "offset_magnitude_011",
                              label = "Offset magnitude (14C yrs)",
                              min = -50,
                              max = 50,
                              value = c(-50, 50)),
                            sliderInput(
                              inputId = "measurement_error_011",
                              label = "Measurement error (14C yrs 1-s)",
                              min = 8,
                              max = 32,
                              value = c(8, 32)
                            ),
                            sliderInput(
                              inputId = "target_year_011",
                              label = "Target year (cal BP)",
                              min = 0, 
                              max = 12310,
                              value = c(0, 12310)
                            )
                            ),
                          #Main panel------------------------------------------
                          mainPanel(
                            verbatimTextOutput("offset_magnitude_011"),
                            verbatimTextOutput("measurement_error_011"),
                            verbatimTextOutput("target_year_011"),
                            verbatimTextOutput("button_1"),
                            verbatimTextOutput("button_2"),
                            plotOutput("plot_011"))
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
#Singles011 EDA----------------------------------------------------------------               
               tabPanel(title = "Single Calibrations 011"),
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