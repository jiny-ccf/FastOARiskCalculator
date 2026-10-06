library(shiny)
library(ggplot2)


# ============================================================
# Statistical calculation functions
# ============================================================

calc_intervention_rate <- function(event_rate_no_trt,
                                   sensitivity,
                                   specificity) {
  
  event_rate_no_trt * sensitivity +
    (1 - event_rate_no_trt) * (1 - specificity)
}


calc_control_rate <- function(event_rate_no_trt,
                              sensitivity,
                              intervention_rate) {
  
  sensitivity * event_rate_no_trt / intervention_rate
}


calc_treatment_rate <- function(relative_risk,
                                control_rate) {
  
  relative_risk * control_rate
}


calc_n_enroll <- function(power,
                          alpha_level,
                          sides,
                          control_rate,
                          treatment_rate) {
  
  result <- power.prop.test(
    power = power,
    sig.level = alpha_level,
    alternative = sides,
    p1 = control_rate,
    p2 = treatment_rate
  )
  
  # power.prop.test() returns the sample size per group.
  # Multiply by 2 for total enrollment.
  ceiling(2 * result$n)
}


calc_n_screen <- function(n_enroll,
                          intervention_rate) {
  
  ceiling(n_enroll / intervention_rate)
}


# ============================================================
# Main sample-size calculation
# ============================================================

calculate_sample_size <- function(event_rate_no_trt,
                                  sensitivity,
                                  specificity,
                                  relative_risk,
                                  power,
                                  alpha_level,
                                  sides) {
  
  intervention_rate <- calc_intervention_rate(
    event_rate_no_trt = event_rate_no_trt,
    sensitivity = sensitivity,
    specificity = specificity
  )
  
  control_rate <- calc_control_rate(
    event_rate_no_trt = event_rate_no_trt,
    sensitivity = sensitivity,
    intervention_rate = intervention_rate
  )
  
  treatment_rate <- calc_treatment_rate(
    relative_risk = relative_risk,
    control_rate = control_rate
  )
  
  n_enroll <- calc_n_enroll(
    power = power,
    alpha_level = alpha_level,
    sides = sides,
    control_rate = control_rate,
    treatment_rate = treatment_rate
  )
  
  n_screen <- calc_n_screen(
    n_enroll = n_enroll,
    intervention_rate = intervention_rate
  )
  
  list(
    intervention_rate = intervention_rate,
    control_rate = control_rate,
    treatment_rate = treatment_rate,
    n_enroll = n_enroll,
    n_screen = n_screen
  )
}


# ============================================================
# Helper for multiple-threshold scenarios
# ============================================================

calculate_scenarios <- function(input,
                                indices,
                                event_rate_no_trt,
                                relative_risk,
                                power,
                                alpha_level,
                                sides) {
  
  lapply(indices, function(i) {
    
    sensitivity <- input[[paste0("sensitivity", i)]]
    specificity <- input[[paste0("specificity", i)]]
    threshold   <- input[[paste0("threshold", i)]]
    
    result <- calculate_sample_size(
      event_rate_no_trt = event_rate_no_trt,
      sensitivity = sensitivity,
      specificity = specificity,
      relative_risk = relative_risk,
      power = power,
      alpha_level = alpha_level,
      sides = sides
    )
    
    list(
      threshold = threshold,
      sensitivity = sensitivity,
      specificity = specificity,
      result = result
    )
  })
}


# ============================================================
# Helper for multiple-threshold plots
# ============================================================

make_sample_size_plot <- function(scenarios) {
  
  plot_data <- do.call(
    rbind,
    lapply(scenarios, function(x) {
      
      data.frame(
        Threshold = x$threshold,
        Action = c("Enroll", "Screen"),
        N = c(
          x$result$n_enroll,
          x$result$n_screen
        )
      )
    })
  )
  
  ggplot(
    plot_data,
    aes(
      x = Threshold,
      y = N,
      group = Action,
      linetype = Action
    )
  ) +
    geom_line(linewidth = 1) +
    geom_point(size = 3) +
    labs(
      title = "Sample Size by Risk Threshold",
      x = "Risk Threshold",
      y = "Sample Size",
      linetype = NULL
    ) +
    scale_x_continuous(
      breaks = plot_data$Threshold
    ) +
    theme_minimal(base_size = 14)
}


# ============================================================
# Shiny server
# ============================================================

server <- function(input, output, session) {
  
  
  # ==========================================================
  # PAGE 1: One Risk Threshold
  # ==========================================================
  
  results1 <- eventReactive(input$calculate1, {
    
    calculate_sample_size(
      event_rate_no_trt = input$eventRateNoTrt1,
      sensitivity = input$sensitivity1,
      specificity = input$specificity1,
      relative_risk = input$relativeRisk1,
      power = input$power1,
      alpha_level = input$alphaLevel1,
      sides = input$sides1
    )
  })
  
  
  output$samplesize1 <- renderTable({
    
    result <- results1()
    
    data.frame(
      Parameters = c(
        "Intervention Rate",
        "Control Event Rate",
        "Treatment Event Rate",
        "Enrollment Sample Size",
        "Screening Sample Size"
      ),
      Value = c(
        result$intervention_rate,
        result$control_rate,
        result$treatment_rate,
        result$n_enroll,
        result$n_screen
      )
    )
  })
  
  
  output$sampleimage1 <- renderPlot({
    
    result <- results1()
    
    plot_data <- data.frame(
      Action = c("Enroll", "Screen"),
      N = c(
        result$n_enroll,
        result$n_screen
      )
    )
    
    ggplot(
      plot_data,
      aes(x = Action, y = N)
    ) +
      geom_col(width = 0.6) +
      geom_text(
        aes(label = N),
        vjust = -0.5,
        size = 5
      ) +
      labs(
        title = "Required Sample Size",
        x = NULL,
        y = "Sample Size"
      ) +
      theme_minimal(base_size = 14)
  })
  
  
  # ==========================================================
  # PAGE 2: Multiple Risk Thresholds — Scenario Set 1
  # ==========================================================
  
  results2 <- eventReactive(input$calculate2, {
    
    calculate_scenarios(
      input = input,
      indices = 2:4,
      event_rate_no_trt = input$eventRateNoTrt2,
      relative_risk = input$relativeRisk2,
      power = input$power2,
      alpha_level = input$alphaLevel2,
      sides = input$sides2
    )
  })
  
  
  output$sampleimage2 <- renderPlot({
    
    make_sample_size_plot(results2())
  })
  
  
  # ==========================================================
  # PAGE 2: Multiple Risk Thresholds — Scenario Set 2
  # ==========================================================
  
  results3 <- eventReactive(input$calculate3, {
    
    calculate_scenarios(
      input = input,
      indices = 5:7,
      event_rate_no_trt = input$eventRateNoTrt3,
      relative_risk = input$relativeRisk3,
      power = input$power3,
      alpha_level = input$alphaLevel3,
      sides = input$sides3
    )
  })
  
  
  output$sampleimage3 <- renderPlot({
    
    make_sample_size_plot(results3())
  })
}
