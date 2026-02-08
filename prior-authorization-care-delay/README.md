## Executive Summary

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

This project analyzes delays between clinical encounters and claim processing to understand how prior authorization and operational timing impact payer efficiency and cost. Using synthetic healthcare data, the analysis focuses on identifying where time gaps occur in the claim lifecycle and how those delays may contribute to increased operational burden and financial risk.

## Business Questions
- What is the average time between a clinical encounter and claim submission?
- Which encounter types or departments experience the longest delays?
- Do longer delays correlate with higher claim costs?
- What operational impact could result from reducing delays?

## Key Metrics
- Average delay (days) between encounter date and claim billing date
- Percentage of claims delayed more than 30 days
- Average claim cost grouped by delay length
- Delay distribution by encounter type

## Analysis Approach
- Join encounter and claim records using service and billing date fields
- Calculate delay intervals in days between encounter start and claim submission
- Apply operational delay thresholds to isolate actionable process delays
- Aggregate delay metrics to identify departments and encounter types with the longest delays

## Deliverables
- SQL queries to calculate delay metrics
- Power BI dashboard summarizing delay patterns
- This README documenting findings and assumptions

## Data Used
This project uses synthetic healthcare data generated for analytical practice.

Primary datasets:
- `encounters.csv` — encounter dates, encounter type, and base cost
- `claims.csv` — service dates, billing dates, and total claim cost
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
- Prior authorization is inferred through timing patterns, not explicit authorization records
- Cost impact estimates are directional, not predictive

## Next Steps
- Introduce simulated prior authorization indicators
- Analyze delay impact on denial likelihood
- Expand analysis to additional payer segments