## Executive Summary

**Primary Decision Question** Which encounter types are experiencing operational delays that drive higher claim costs, and where should intervention be prioritized?

This analysis examines the timing between clinical encounters and claim submission to identify operational delays that meaningfully impact claim cost. The resulting dashboard is designed to support Claims Operations teams in prioritizing intervention efforts for high-delay, high-cost encounter types.

Analysis of encounter-to-claim timing revealed measurable operational delays that correlate with higher claim costs. Claims submitted more than 30 days after service accounted for a disproportionate share of total claim spend, indicating that administrative lag is not just a timing issue but a cost driver.

Applying a 0–365 day operational window isolated actionable delays while excluding non-operational outliers. Results highlight specific encounter types with consistently longer delays, presenting clear opportunities for targeted process improvement and cost containment.

## Recommendations

| Function            | Recommendation                                                                 | Expected Impact |
|---------------------|----------------------------------------------------------------------------------|-----------------|
| Operations           | Review workflows for encounters with delays exceeding 30 days to identify intake or submission bottlenecks. | Reduced claim cycle time |
| Provider Relations   | Educate high-delay encounter types on documentation and submission timelines.   | Fewer late submissions |
| Claims Operations    | Prioritize monitoring of claims exceeding 30 days post-service.                | Earlier intervention |
| Finance              | Track average delay days as an operational KPI alongside claim cost metrics.    | Improved cost visibility |

## Project Summary

This project analyzes delays between clinical encounters and claim submission to understand how billing cycle timing impacts payer operational efficiency and cost. Using synthetic healthcare claims data, the analysis focuses on identifying where time gaps occur between service and billing, and how those delays contribute to increased financial burden and administrative risk.

## Business Questions
- What is the average time between a clinical encounter and claim submission?
- Which encounter types experience the longest billing delays?
- Do longer delays correlate with higher claim costs?
- Where should Claims Operations prioritize intervention?

## Key Metrics
- Average delay (days) between encounter date and claim billing date
- Percentage of claims delayed more than 30 days
- Average claim cost grouped by delay length
- Delay distribution by encounter type

## Analysis Approach
- Join encounter and claim records using patient and service date alignment
- Calculate delay intervals in days between encounter start (START) and claim billing date (LASTBILLEDDATE1)
- Apply operational delay thresholds (0–365 days) to isolate actionable process delays
- Aggregate delay metrics to identify encounter types with the longest billing lag

## Deliverables
- SQL queries to calculate billing delay metrics
- Power BI dashboard summarizing delay patterns and cost impact
- This README documenting findings, assumptions, and validation rules

## Data Used
This project uses synthetic healthcare claims data generated for analytical modeling.

Primary datasets:
- `encounters.csv` — encounter dates, encounter class, and total claim cost
- `claims.csv` — service dates, billing dates, and simulated delay value
- `patients.csv` — basic member demographics
- `payers.csv` — payer coverage and payment information

## Data Validation Notes
- Date fields were checked for null or negative values
- Encounter dates were verified to occur before billing dates
- Records failing validation were excluded from analysis
- Claims with delay values outside the 0–365 day window (4 records) were excluded as non-operational outliers.
- Encounter date is defined as the `START` timestamp from `encounters.csv`.
- Claim submission date is defined as `LASTBILLEDDATE1` from `claims.csv`.

## Limitations
- Data is synthetic and does not represent real patients
- Billing delay is modeled using simulated delay fields
- Cost impact estimates are directional, not predictive

## Next Steps
- Expand analysis to financial leakage using claims transaction data
- Analyze outstanding balances by encounter type
- Evaluate provider-level billing performance variation