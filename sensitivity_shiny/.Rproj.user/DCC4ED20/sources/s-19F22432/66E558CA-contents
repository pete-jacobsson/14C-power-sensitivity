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
                            radioButtons(
                              inputId = "x_axis_text_011",
                              label = "Choose variable:",
                              choices = list("Offset Magfnitude" = "offset_magnitude",
                                             "Measurement Error" = "measurement_error",
                                             "Target Date" = "target_year"),
                              selected = "offset_magnitude"
                            ),
                            radioButtons(
                              inputId = "y_axis_text_011",
                              label = "Choose HPD Area",
                              choices = list("68% HPD Area" = "accuracy_68",
                                             "95% HPD Area" = "accuracy_95"),
                              selected = "accuracy_68"
                            ),
                            #Set up sliders------------------------------------
                            sliderInput(
                              inputId = "offset_magnitude_011",
                              label = "Offset Magnitude (14C yrs)",
                              min = -50,
                              max = 50,
                              value = c(-50, 50)),
                            sliderInput(
                              inputId = "measurement_error_011",
                              label = "Measurement Error (14C yrs 1-s)",
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
                            textOutput("x_axis_text_011"),
                            textOutput("y_axis_text_011"),
                            verbatimTextOutput("offset_magnitude_011"),
                            verbatimTextOutput("measurement_error_011"),
                            verbatimTextOutput("target_year_011"),
                            plotOutput("plotting_table_011"))
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