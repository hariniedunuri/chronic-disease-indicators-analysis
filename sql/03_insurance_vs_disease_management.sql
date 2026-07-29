-- Research Question 3: How does health insurance coverage correlate with chronic disease
-- management (asthma / heart disease) across regions?

WITH coverage AS (
    SELECT LocationAbbr, YearStart, AVG(DataValueAlt) AS avg_coverage_pct
    FROM chronic_disease_indicators
    WHERE Topic = 'Health Status'
      AND Question ILIKE '%health insurance%'
      AND StratificationCategory1 = 'Overall'
    GROUP BY LocationAbbr, YearStart
),
disease_mgmt AS (
    SELECT LocationAbbr, YearStart, Topic, AVG(DataValueAlt) AS avg_prevalence
    FROM chronic_disease_indicators
    WHERE Topic IN ('Asthma','Cardiovascular Disease')
      AND StratificationCategory1 = 'Overall'
    GROUP BY LocationAbbr, YearStart, Topic
)
SELECT
    c.LocationAbbr,
    c.YearStart,
    c.avg_coverage_pct,
    m.Topic,
    m.avg_prevalence
FROM coverage c
JOIN disease_mgmt m
  ON c.LocationAbbr = m.LocationAbbr AND c.YearStart = m.YearStart
ORDER BY c.LocationAbbr, c.YearStart;
