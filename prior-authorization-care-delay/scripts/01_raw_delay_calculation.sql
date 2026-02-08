-- Raw care delay calculation (no exclusions applied)

SELECT
    e.Id AS encounter_id,
    e.START AS encounter_start_date,
    c.LASTBILLEDDATE1 AS claim_submission_date,
    DATEDIFF(day, e.START, c.LASTBILLEDDATE1) AS delay_days,
    c.TOTAL_CLAIM_COST
FROM encounters e
JOIN claims c
    ON e.Id = c.ENCOUNTERID;
