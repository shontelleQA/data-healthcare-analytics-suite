-- Average care delay by encounter type

SELECT
    e.CODE AS encounter_type,
    COUNT(*) AS total_claims,
    AVG(DATEDIFF(day, e.START, c.LASTBILLEDDATE1)) AS avg_delay_days,
    AVG(c.TOTAL_CLAIM_COST) AS avg_claim_cost
FROM encounters e
JOIN claims c
    ON e.Id = c.ENCOUNTERID
WHERE DATEDIFF(day, e.START, c.LASTBILLEDDATE1) BETWEEN 0 AND 365
GROUP BY
    e.CODE
ORDER BY
    avg_delay_days DESC;
