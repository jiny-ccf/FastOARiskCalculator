# FastOA risk calculator - 11/17/2022

library(shiny)
library(shinythemes)
library(ggplot2)
#install.packages("shinyMatrix")
library(shinyMatrix)

#Using a 'fancy' shinytheme

ui <- navbarPage(
  theme = shinytheme("yeti"), 
  title = span("Advanced Sample Size Calculation for Clinical Trials Enriched with High-Risk Patients",
               style = 'font-size:32px'),
  
  navlistPanel(
    id = 'mainPage',
    'Options',
    tabPanel(
      title = 'One Risk Threshold',
      sidebarLayout(
        sidebarPanel(
          sliderInput(inputId = 'threshold1',
                      label = 'Risk Threshold',
                      min = 0,
                      max = 1,
                      value = 0.1),
          
          numericInput(inputId = 'eventRateNoTrt1',
                       label = 'Event Rate without Intervention',
                       value = 0.20),
          
          numericInput(inputId = 'sensitivity1',
                       label = 'Sensitivity',
                       value = 0.47),
          
          numericInput(inputId = 'specificity1',
                       label = 'Specificity',
                       value = 0.96),
          
          numericInput(inputId = 'relativeRisk1',
                       label = 'Relative Risk',
                       value = 0.75),
          
          numericInput(inputId = 'power1',
                       label = 'Power',
                       value = 0.8),
          
          numericInput(inputId = 'alphaLevel1',
                       label = 'Alpha Level',
                       value = 0.05),
          
          radioButtons(inputId = 'sides1',
                       label = 'Sides',
                       choices = c("two.sided", "one.sided")),
          
          actionButton("calculate1", "Calculate")
        ),
        mainPanel(
          fluidRow(
            column(
              5,
              tableOutput(outputId = "samplesize1")
            ),
            column(
              10,
              plotOutput(outputId = "sampleimage1")
            )
          )
        )
      )
    ),
    tabPanel(
      title = 'Multiple Risk Thresholds',
      
      splitLayout(
        fluidPage(
          fluidRow(
            column(
              6,
              numericInput(inputId = 'eventRateNoTrt2',
                           label = 'Event Rate without Intervention',
                           value = 0.1658)
            ),
            column(
              6,
              numericInput(inputId = 'relativeRisk2',
                           label = 'Relative Risk',
                           value = 0.60)
            )
          ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'threshold2',
                          label = 'Risk Threshold',
                          value = 0.1)
              ),
            column(
              4,
              numericInput(inputId = 'sensitivity2',
                           label = 'Sensitivity',
                           value = 0.83)
              ),
            column(
              4,
              numericInput(inputId = 'specificity2',
                           label = 'Specificity',
                           value = 0.42)
              )
            ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'threshold3',
                           label = 'Risk Threshold',
                           value = 0.2)
            ),
            column(
              4,
              numericInput(inputId = 'sensitivity3',
                           label = 'Sensitivity',
                           value = 0.54)
            ),
            column(
              4,
              numericInput(inputId = 'specificity3',
                           label = 'Specificity',
                           value = 0.78)
            )
          ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'threshold4',
                           label = 'Risk Threshold',
                           value = 0.3)
            ),
            column(
              4,
              numericInput(inputId = 'sensitivity4',
                           label = 'Sensitivity',
                           value = 0.35)
            ),
            column(
              4,
              numericInput(inputId = 'specificity4',
                           label = 'Specificity',
                           value = 0.91)
            )
          ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'power2',
                           label = 'Power',
                           value = 0.8)
            ),
            column(
              4,
              numericInput(inputId = 'alphaLevel2',
                           label = 'Alpha Level',
                           value = 0.05)
            ),
            column(
              4,
              radioButtons(inputId = 'sides2',
                           label = 'Sides',
                           choices = c("two.sided", "one.sided"))
            )
          ),
          fluidRow(
            column(
              12,
              actionButton("calculate2", "Calculate")
            )
          ),
          plotOutput(outputId = "sampleimage2")
        ),
        
        fluidPage(
          fluidRow(
            column(
              6,
              numericInput(inputId = 'eventRateNoTrt3',
                           label = 'Event Rate without Intervention',
                           value = 0.1658)
            ),
            column(
              6,
              numericInput(inputId = 'relativeRisk3',
                           label = 'Relative Risk',
                           value = 0.65)
            )
          ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'threshold5',
                          label = 'Risk Threshold',
                          value = 0.1)
            ),
            column(
              4,
              numericInput(inputId = 'sensitivity5',
                           label = 'Sensitivity',
                           value = 0.83)
            ),
            column(
              4,
              numericInput(inputId = 'specificity5',
                           label = 'Specificity',
                           value = 0.42)
            )
          ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'threshold6',
                           label = 'Risk Threshold',
                           value = 0.2)
            ),
            column(
              4,
              numericInput(inputId = 'sensitivity6',
                           label = 'Sensitivity',
                           value = 0.54)
            ),
            column(
              4,
              numericInput(inputId = 'specificity6',
                           label = 'Specificity',
                           value = 0.78)
            )
          ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'threshold7',
                           label = 'Risk Threshold',
                           value = 0.3)
            ),
            column(
              4,
              numericInput(inputId = 'sensitivity7',
                           label = 'Sensitivity',
                           value = 0.35)
            ),
            column(
              4,
              numericInput(inputId = 'specificity7',
                           label = 'Specificity',
                           value = 0.91)
            )
          ),
          fluidRow(
            column(
              4,
              numericInput(inputId = 'power3',
                           label = 'Power',
                           value = 0.8)
            ),
            column(
              4,
              numericInput(inputId = 'alphaLevel3',
                           label = 'Alpha Level',
                           value = 0.05)
            ),
            column(
              4,
              radioButtons(inputId = 'sides3',
                           label = 'Sides',
                           choices = c("two.sided", "one.sided"))
            )
          ),
          fluidRow(
            column(
              12,
              actionButton("calculate3", "Calculate")
            )
          ),
          plotOutput(outputId = "sampleimage3")
        )
        )
      )
    )
  )
