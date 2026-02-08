-- Inspect delay distribution before applying exclusions

SELECT
    MIN(DATEDIFF(day, e.START, c.LASTBILLEDDATE1)) AS min_delay_days,
    MAX(DATEDIFF(day, e.START, c.LASTBILLEDDATE1)) AS max_delay_days,
    COUNT(*) AS total_records
FROM encounters e
JOIN claims c
    ON e.Id = c.ENCOUNTERID;
