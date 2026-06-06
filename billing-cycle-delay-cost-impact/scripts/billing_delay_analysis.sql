USE DATABASE HEALTHCARE_ANALYTICS;
USE SCHEMA PUBLIC;

-- ==========================================
-- SECTION 1: DATA VALIDATION
-- ==========================================

-- Step 1a: Inspect raw CLAIMS data
-- Purpose: Confirm column names, data types, and general structure

SELECT *
FROM CLAIMS
LIMIT 10;

-- Step 1b: Validate row count in CLAIMS
-- Purpose: Establish baseline record count for comparison during join validation

SELECT
    COUNT(*) AS total_claims
FROM CLAIMS;


-- Step 2a: Preview join between CLAIMS and ENCOUNTERS
-- Purpose: Visually confirm that APPOINTMENTID correctly links to encounter data
-- Note: LEFT JOIN used here to identify any unmatched records

SELECT
    c.SERVICEDATE,
    c.LASTBILLEDDATE1,
    e.ENCOUNTERCLASS
FROM CLAIMS c
LEFT JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id
LIMIT 50;



-- Step 2b: Validate join integrity (row count comparison)
-- Purpose: Ensure all claims successfully match to an encounter
-- Expected: matched_claims ≈ total_claims

SELECT
    COUNT(*) AS matched_claims
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id;


-- ==========================================
-- SECTION 2: BILLING DELAY METRIC
-- ==========================================


-- Step 3: Calculate billing delay (core metric)
-- Purpose: Measure time between encounter start and claim billing date
-- Logic: delay_days = LASTBILLEDDATE1 - START_DATE
-- Note: Using INNER JOIN since unmatched records have been validated

SELECT
    c.APPOINTMENTID,
    e.ENCOUNTERCLASS,
    e.START_DATE,
    c.LASTBILLEDDATE1,
    DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) AS delay_days
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id
LIMIT 50;



-- Step 4: Validate delay distribution
-- Purpose: Identify anomalies such as negative delays or extreme values
-- Expected:
--   min_delay >= 0
--   max_delay within a reasonable operational range

SELECT
    MIN(DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1)) AS min_delay,
    MAX(DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1)) AS max_delay,
    AVG(DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1)) AS avg_delay
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id;



-- Step 5: Apply operational delay window (0–365 days)
-- Purpose: Filter the joined claims-encounter dataset to exclude invalid or non-operational delay values

SELECT
    c.APPOINTMENTID,
    e.ENCOUNTERCLASS,
    e.START_DATE,
    c.LASTBILLEDDATE1,
    DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) AS delay_days
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365
LIMIT 50;



-- ==========================================
-- SECTION 3: ANALYSIS
-- ==========================================


-- Step 6: Calculate average billing delay
-- Purpose: Get a baseline for how long claims take to be billed

SELECT
    AVG(DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1)) AS avg_delay_days
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365;


-- Finding:
-- Average billing delay = 14.66 days.
-- On average, claims are billed approximately two weeks after the encounter.



-- Step 7: Calculate percent of claims delayed more than 30 days
-- Purpose: Identify how much of the dataset falls outside normal billing timelines

SELECT
    COUNT(*) AS total_claims,
    SUM(CASE
            WHEN DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) > 30 THEN 1
            ELSE 0
        END) AS delayed_claims,
    ROUND(
        SUM(CASE
                WHEN DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) > 30 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
        2
    ) AS pct_delayed_over_30
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365;


-- Finding:
-- 5.87% of claims were billed more than 30 days after the encounter.
-- Most claims fall within expected billing timelines.



-- Step 8: Measure cost tied to claims delayed more than 30 days
-- Purpose: See whether delayed claims represent a meaningful share of total claim cost

SELECT
    SUM(e.TOTAL_CLAIM_COST) AS total_claim_cost,

    SUM(CASE
            WHEN DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) > 30
            THEN e.TOTAL_CLAIM_COST
            ELSE 0
        END) AS delayed_claim_cost,

    ROUND(
        SUM(CASE
                WHEN DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) > 30
                THEN e.TOTAL_CLAIM_COST
                ELSE 0
            END) * 100.0 / SUM(e.TOTAL_CLAIM_COST),
        2
    ) AS pct_cost_delayed
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365;


-- Finding:
-- 5.87% of claims were delayed more than 30 days.
-- Those delayed claims accounted for 13.86% of total claim cost.



-- Step 9: Calculate average delay by encounter type
-- Purpose: Identify which encounter types experience the longest billing delays

SELECT
    e.ENCOUNTERCLASS,
    COUNT(*) AS claim_count,
    ROUND(AVG(DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1)),2) AS avg_delay_days
FROM CLAIMS c
JOIN ENCOUNTERS e
    ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365
GROUP BY e.ENCOUNTERCLASS
ORDER BY avg_delay_days DESC;


-- Finding:
-- Inpatient encounters had the longest average billing delay at 105.64 days.
-- Emergency encounters had the second-longest average delay at 52.13 days.
-- Wellness encounters had the shortest average delay at 4.00 days.
-- Billing delay varies significantly by encounter type.



-- Step 10: Measure delayed cost by encounter type
-- Purpose: See which encounter types are driving the most cost from claims delayed more than 30 days

SELECT
    e.ENCOUNTERCLASS,
    COUNT(*) AS delayed_claims,
    ROUND(SUM(e.TOTAL_CLAIM_COST), 2) AS delayed_claim_cost
FROM CLAIMS c
JOIN ENCOUNTERS e
  ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) > 30
  AND DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) <= 365
GROUP BY e.ENCOUNTERCLASS
ORDER BY delayed_claim_cost DESC;


-- Finding:
-- Inpatient and emergency encounters account for the vast majority of delayed claim cost.
-- Together, these encounter types represent approximately 92.6% of all cost associated with claims delayed more than 30 days.
-- Claims Operations should prioritize investigation of inpatient and emergency billing workflows before lower-cost encounter types.



-- Step 11: Calculate average claim cost by encounter type
-- Purpose: Compare encounter costs across encounter types and provide context for delayed cost findings

SELECT
    e.ENCOUNTERCLASS,
    COUNT(*) AS claim_count,
    ROUND(AVG(e.TOTAL_CLAIM_COST), 2) AS avg_claim_cost,
    ROUND(SUM(e.TOTAL_CLAIM_COST), 2) AS total_claim_cost
FROM CLAIMS c
JOIN ENCOUNTERS e
    ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365
GROUP BY e.ENCOUNTERCLASS
ORDER BY avg_claim_cost DESC;


-- Finding:
-- Emergency and inpatient encounters have the highest average claim costs
-- ($11,814 and $10,948 respectively).
-- These same encounter types also experience the longest billing delays.
-- The financial impact of billing delays is concentrated in the most expensive
-- encounter categories, making inpatient and emergency workflows the highest
-- priority areas for operational review.



-- Step 12: Calculate delayed claim rate by encounter type
-- Purpose: Identify which encounter types are most likely to exceed the 30-day billing threshold

SELECT
    e.ENCOUNTERCLASS,
    COUNT(*) AS total_claims,

    SUM(
        CASE
            WHEN DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) > 30
            THEN 1
            ELSE 0
        END
    ) AS delayed_claims,

    ROUND(
        SUM(
            CASE
                WHEN DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) > 30
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS pct_delayed_over_30
FROM CLAIMS c
JOIN ENCOUNTERS e
    ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365
GROUP BY e.ENCOUNTERCLASS
ORDER BY pct_delayed_over_30 DESC;


-- Finding:
-- Billing delays are highly concentrated within inpatient and emergency encounters.
-- Nearly all inpatient claims (99.29%) exceeded the 30-day threshold,
-- while 77.51% of emergency claims exceeded 30 days.
-- Outpatient, ambulatory, and wellness encounters showed no meaningful delay exposure.
-- The issue appears localized rather than system-wide.


-- ==========================================
-- SECTION 4: FINDING VALIDATION
-- ==========================================


-- Validation Check: Look for any claims over 30 days by encounter type
-- Purpose: Confirm whether outpatient, ambulatory, and wellness truly have no delays over 30 days

SELECT
    e.ENCOUNTERCLASS,
    MAX(DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1)) AS max_delay_days
FROM CLAIMS c
JOIN ENCOUNTERS e
    ON c.APPOINTMENTID = e.Id
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) BETWEEN 0 AND 365
GROUP BY e.ENCOUNTERCLASS
ORDER BY max_delay_days DESC;


-- Validation Note:
-- Outpatient, ambulatory, and wellness encounters showed 0% of claims delayed
-- beyond 30 days. Additional validation confirmed that the maximum observed
-- delays for these encounter types were 30, 25, and 7 days respectively.
-- This behavior appears to be a characteristic of the source dataset rather
-- than a query or calculation issue.



-- ==========================================
-- SECTION 5: POWER BI DATASET EXPORT
-- ==========================================

-- Purpose:
-- Create a row-level dataset for Power BI dashboard development.
-- This dataset includes encounter type, billing delay, and claim cost
-- for dashboard visualizations and KPI calculations.

SELECT
    c.APPOINTMENTID,
    e.ENCOUNTERCLASS,
    e.START_DATE,
    c.LASTBILLEDDATE1,
    DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1) AS DELAY_DAYS,
    e.TOTAL_CLAIM_COST
FROM CLAIMS c
JOIN ENCOUNTERS e
    ON c.APPOINTMENTID = e.ID
WHERE DATEDIFF('day', e.START_DATE, c.LASTBILLEDDATE1)
      BETWEEN 0 AND 365;