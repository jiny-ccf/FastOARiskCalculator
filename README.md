# FastOA Risk Calculator

### Advanced sample size calculation for clinical trials enriched with high-risk patients

[![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-Interactive%20App-1f9e89)](https://yuxuanjin.shinyapps.io/samplesizecalculator/)

> **Design clinical trials around the patients most likely to experience the outcome.**

FastOA Risk Calculator is an interactive **R/Shiny research tool for sample-size planning of clinical trials enriched with high-risk patients**.

The calculator evaluates how predictive-model performance, risk thresholds, expected event rates, treatment effects, statistical power, and significance levels interact to determine the number of patients who must be **screened** and **enrolled**.

**Live application:**
[Launch FastOA Risk Calculator](https://yuxuanjin.shinyapps.io/samplesizecalculator/)

---

## Why FastOA?

Traditional clinical trials often recruit broad patient populations, even when only a subset is likely to experience the outcome of interest during the study period.

For osteoarthritis prevention trials, this can be particularly challenging. If the outcome develops relatively infrequently, a conventional trial may require a very large number of participants and long follow-up.

The **FastOA** framework proposes a different strategy:

```text
General population
       │
       ▼
Risk prediction model
       │
       ▼
 ┌───────────────┐
 │ High-risk     │
 │ participants  │
 └───────────────┘
       │
       ▼
 Enriched clinical trial
       │
       ▼
More events per participant
       │
       ▼
Potentially smaller trial
```

The underlying FastOA concept is described by Felson et al. in *Annals of the Rheumatic Diseases*. The authors propose identifying individuals at high risk of rapidly developing post-traumatic OA and enriching clinical trials with these participants.

---

## What this calculator does

The application translates the performance of a risk prediction model into **trial recruitment requirements**.

Given:

* expected event rate without intervention
* sensitivity of the risk threshold
* specificity of the risk threshold
* selected risk threshold
* expected relative risk under intervention
* statistical power
* alpha level
* one- or two-sided testing

the calculator estimates:

| Quantity                   | Description                                                                  |
| -------------------------- | ---------------------------------------------------------------------------- |
| **Intervention rate**      | Proportion of screened participants identified for trial enrollment          |
| **Control event rate**     | Expected event rate among enriched participants without intervention         |
| **Treatment event rate**   | Expected event rate after intervention                                       |
| **Enrollment sample size** | Number of high-risk participants required for the randomized trial           |
| **Screening sample size**  | Number of individuals who must be screened to obtain the required enrollment |

This creates a direct connection between **risk-model performance** and **clinical trial feasibility**.

---

## Implementation

The application is implemented in **R and Shiny**.

The code is intentionally lightweight: the statistical calculations are separated from the Shiny interface, while the application provides an interactive layer for exploring trial-design scenarios.

### Repository structure

```text
FastOARiskCalculator/
│
├── ui.R
├── server.R
├── README.md
└── LICENSE
```

The application consists of two primary components:

```text
ui.R
 │
 ├── One Risk Threshold
 │
 └── Multiple Risk Thresholds
          │
          ├── Scenario A
          │   ├── Threshold 1
          │   ├── Threshold 2
          │   └── Threshold 3
          │
          └── Scenario B
              ├── Threshold 1
              ├── Threshold 2
              └── Threshold 3
                   
                    ↓
                 
                 server.R
                    │
                    ├── Risk enrichment
                    ├── Event-rate calculation
                    ├── Power calculation
                    └── Sample-size visualization
```

---

## Running locally

Clone the repository:

```bash
git clone https://github.com/jiny-ccf/FastOARiskCalculator.git
cd FastOARiskCalculator
```

Install the required R packages:

```r
install.packages(c(
  "shiny",
  "shinythemes",
  "ggplot2",
  "shinyMatrix"
))
```

Launch the application:

```r
shiny::runApp()
```

The application should open automatically in your browser.

---

## Research motivation

The FastOA framework was developed to address a fundamental challenge in osteoarthritis treatment development: clinical trials may be conducted in populations where relatively few participants experience meaningful disease progression during the study period.

The FastOA viewpoint proposes identifying people at high risk of rapidly developing post-traumatic OA and using this enriched population for prevention trials. In the published discussion, the authors note that selecting higher-risk participants can substantially reduce the sample size required compared with recruiting a broader population.

This calculator operationalizes that idea from a **trial-design perspective**:

> **How much can a clinical trial gain by enriching enrollment using a risk prediction model?**

---

## Publication

The methodology and clinical motivation are closely related to:

> Felson DT, Lotz M, Jin Y, Jones M, Kim JS, Spindler K.
> **New approach to testing treatments for osteoarthritis: FastOA.**
> *Annals of the Rheumatic Diseases.* 2024;83(3):274–276.
> DOI: **10.1136/ard-2023-224675**

[Read the full article — Annals of the Rheumatic Diseases](https://ard.bmj.com/content/annrheumdis/83/3/274.full.pdf?utm_source=chatgpt.com)

The article describes FastOA as an approach for identifying individuals at high risk of rapidly developing post-traumatic OA and enriching clinical trials with these participants.

---

## Conference presentation

### ASA Conference on Statistical Practice 2023

**Advanced Sample Size Calculation for Clinical Trials Enriched with High Risk Patients**

The presentation introduced the statistical framework underlying this calculator and demonstrated how risk-threshold performance can be incorporated into clinical-trial sample-size planning.

---

## Intended use

This application is intended as a **research and trial-design planning tool**.

It can be useful for:

* evaluating candidate risk thresholds
* estimating screening requirements
* comparing trial-enrichment strategies
* exploring sensitivity/specificity trade-offs
* assessing the potential efficiency of risk-enriched clinical trials
* communicating trial-design assumptions with clinical investigators

It is not intended to replace a formal statistical analysis plan or protocol-specific sample-size calculation.

---

## Citation

If you use this calculator or adapt the underlying methodology in research, please cite the FastOA publication:

```bibtex
@article{felson2024fastoa,
  title   = {New approach to testing treatments for osteoarthritis: FastOA},
  author  = {
    Felson, David T. and
    Lotz, Martin and
    Jin, Yuxuan and
    Jones, Morgan and
    Kim, Jason S. and
    Spindler, Kurt
  },
  journal = {Annals of the Rheumatic Diseases},
  volume  = {83},
  number  = {3},
  pages   = {274--276},
  year    = {2024},
  doi     = {10.1136/ard-2023-224675}
}
```

---

## License

This project is distributed under the MIT License.

See [`LICENSE`](LICENSE) for details.

---

## Links

* **Live calculator:** https://yuxuanjin.shinyapps.io/samplesizecalculator/
* **Source code:** https://github.com/jiny-ccf/FastOARiskCalculator
* **FastOA publication:** https://doi.org/10.1136/ard-2023-224675

---


