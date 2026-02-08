## Project Summary

This project analyzes delays between clinical encounters and claim processing to understand how prior authorization and operational timing impact payer efficiency and cost. Using synthetic healthcare data, the analysis focuses on identifying where time gaps occur in the claim lifecycle and how those delays may contribute to increased operational burden and financial risk.

## Business Questions
- What is the average time between a clinical encounter and claim submission?
- Which encounter types or departments experience the longest delays?
- Do longer delays correlate with higher claim costs?
- What operational impact could result from reducing delays?

## Data Used
This project uses synthetic healthcare data generated for analytical practice.

Primary datasets:
- `encounters.csv` — encounter dates, encounter type, and base cost
- `claims.csv` — service dates, billing dates, and total claim cost
- `patients.csv` — basic member demographics
- `payers.csv` — payer coverage and payment information
---
- Encounter date is defined as the `START` timestamp from `encounters.csv`.


## Key Metrics
- Average delay (days) between encounter date and claim billing date
- Percentage of claims delayed more than 30 days
- Average claim cost grouped by delay length
- Delay distribution by encounter type

## Analysis Approach
- Join encounters and claims using encounter and service dates
- Calculate delay intervals using date differences
- Group and aggregate delays by encounter type and cost
- Validate date logic to ensure no negative or missing values

## Deliverables
- SQL queries to calculate delay metrics
- Python notebook for exploratory analysis
- Power BI dashboard summarizing delay patterns
- This README documenting findings and assumptions

## Data Validation Notes
- Date fields were checked for null or negative values
- Encounter dates were verified to occur before billing dates
- Records failing validation were excluded from analysis

## Limitations
- Data is synthetic and does not represent real patients
- Prior authorization is inferred through timing patterns, not explicit authorization records
- Cost impact estimates are directional, not predictive

## Next Steps
- Introduce simulated prior authorization indicators
- Analyze delay impact on denial likelihood
- Expand analysis to additional payer segments