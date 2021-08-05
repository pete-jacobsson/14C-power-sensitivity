#Navbar on outer envelope------------------------------------------------------

shinyUI(
  navbarPage(
    title = "14C Sensitivity",
    tabPanel(title = "Home"),
    navbarMenu(title = "EDA",
               tabPanel(title = "Single Calibrations 011",
                        sidebarLayout(
                          sidebarPanel(
                            "String inside sidebar",
                            varSelectInput(
                              inputId = "x_axis_text_011",
                              label = "Choose a column from the data",
                              data = singles_011_results
                            )),
                          mainPanel(
                            textOutput("x_axis_text_011"))
                        )
                        ),
               tabPanel(title = "Wiggle-match Dates 021"),
               tabPanel(title = "Wiggle-match Dates 023"),
               tabPanel(title = "Wiggle-match Dates 024"),
               tabPanel(title = "Wiggle-match Dates 025"),
               tabPanel(title = "Uniform Bound Sequences 031"),
               tabPanel(title = "Uniform Bound Sequences 033")
               ),
    navbarMenu(title = "Maximum Permissible Error",
               tabPanel(title = "Single Calibrations 011"),
               tabPanel(title = "Wiggle match Dates 021"),
               tabPanel(title = "Wiggle match Dates 022"),
               tabPanel(title = "Wiggle match Dates 023"),
               tabPanel(title = "Wiggle match Dates 024"),
               tabPanel(title = "Wiggle match Dates 025"),
               tabPanel(title = "Uniform Bound Sequences 031"),
               tabPanel(title = "Uniform Bound Sequences 032"),
               tabPanel(title = "Uniform Bound Sequences 033")
               ),
    navbarMenu(title = "Modelling")
    
  )
)