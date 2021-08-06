ui <- fluidPage(
    selectInput("vars", "Variables", names(mtcars), multiple = TRUE),
    tableOutput("count")
)

server <- function(input, output, session) {
    output$count <- renderTable({
        req(input$vars)
        
        mtcars %>% 
            group_by(across(all_of(input$vars))) %>% 
            summarise(n = n(), .groups = "drop")
    })
}