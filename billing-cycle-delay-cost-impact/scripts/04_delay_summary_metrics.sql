-- Summary delay metrics after applying operational exclusions

SELECT
    COUNT(*) AS total_claims,
    AVG(DATEDIFF(day, e.START, c.LASTBILLEDDATE1)) AS avg_delay_days,
    MIN(DATEDIFF(day, e.START, c.LASTBILLEDDATE1)) AS min_delay_days,
    MAX(DATEDIFF(day, e.START, c.LASTBILLEDDATE1)) AS max_delay_days
FROM encounters e
JOIN claims c
    ON e.Id = c.ENCOUNTERID
WHERE DATEDIFF(day, e.START, c.LASTBILLEDDATE1) BETWEEN 0 AND 365;
