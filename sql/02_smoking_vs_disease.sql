-- Research Question 1: How do smoking rates correlate with heart disease / lung cancer
-- incidence across demographic groups?

WITH smoking AS (
    SELECT
        LocationAbbr,
        YearStart,
        Stratification1 AS demographic_group,
        AVG(DataValueAlt) AS avg_smoking_rate
    FROM chronic_disease_indicators
    WHERE Topic = 'Tobacco'
      AND Question ILIKE '%current smoking%'
      AND StratificationCategory1 IN ('Overall','Gender','Race/Ethnicity')
    GROUP BY LocationAbbr, YearStart, Stratification1
),
disease AS (
    SELECT
        LocationAbbr,
        YearStart,
        Stratification1 AS demographic_group,
        Topic,
        AVG(DataValueAlt) AS avg_rate
    FROM chronic_disease_indicators
    WHERE Topic IN ('Cardiovascular Disease','Cancer')
      AND DataValueType = 'Age-adjusted Rate'
      AND StratificationCategory1 IN ('Overall','Gender','Race/Ethnicity')
    GROUP BY LocationAbbr, YearStart, Stratification1, Topic
)
SELECT
    s.LocationAbbr,
    s.YearStart,
    s.demographic_group,
    s.avg_smoking_rate,
    d.Topic AS disease_topic,
    d.avg_rate AS disease_rate
FROM smoking s
JOIN disease d
  ON s.LocationAbbr = d.LocationAbbr
 AND s.YearStart = d.YearStart
 AND s.demographic_group = d.demographic_group
ORDER BY s.LocationAbbr, s.YearStart;
