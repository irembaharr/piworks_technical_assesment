WITH imputed AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY country ORDER BY daily_vaccinations) AS rank
  FROM your_table
)
UPDATE imputed
SET daily_vaccinations = (
  SELECT median(daily_vaccinations)
  FROM imputed i2
  WHERE i2.country = imputed.country
  AND i2.rank <= imputed.rank
)
WHERE daily_vaccinations IS NULL;