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
                            "String inside sidebar",
                            varSelectInput(
                              inputId = "x_axis_text_011",
                              label = "Choose a column from the data",
                              data = singles_011_results
                            ),
                            varSelectInput(
                              inputId = "y_axis_text_011",
                              label = "Choose a column from the data",
                              data = singles_011_results
                            )
                            
                            ),
                          mainPanel(
                            textOutput("x_axis_text_011"),
                            textOutput("y_axis_text_011"))
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