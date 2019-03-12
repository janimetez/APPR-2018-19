library(shiny)

shinyUI(fluidPage(
  
  titlePanel(""),
  
  tabsetPanel(
    tabPanel("Število umrlih v cestnoprometnih nesrečah na 10.000 prebivalcev",
             sidebarPanel(
               checkboxGroupInput(inputId="regija", label = "Izberi regije:",
                                  choiceNames=c("Gorenjska", "Goriška", "Jugovzhodna", "Koroška", "Obalno-kraška", "Osrednjeslovenska", "Podravska", "Pomurska", "Posavska", "Primorsko-notranjska", "Savinjska", "Zasavska"),
                                  choiceValues =c("Gorenjska", "Goriška", "Jugovzhodna", "Koroška", "Obalno-kraška", "Osrednjeslovenska", "Podravska", "Pomurska", "Posavska", "Primorsko-notranjska", "Savinjska", "Zasavska"),
                                  selected = "Jugovzhodna")
             ),
             mainPanel(plotOutput("regija1"))),

   tabPanel("Število osebnih avtomobilov na 1000 prebivalcev",
           sidebarPanel(
             sliderInput("Leto", "Izberi leto", min = 2001, max = 2017,
                         value = 2001, step = 1, sep='', animate = animationOptions(interval=250))
           ),
           mainPanel(plotOutput("avto")))
  )
))







