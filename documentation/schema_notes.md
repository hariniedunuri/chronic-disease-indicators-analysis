# CDI Schema Notes

The raw CDC CDI export has 34 columns; `DataValueAlt` is the clean numeric field to filter
and aggregate on (`DataValue` is text and carries footnote symbols). Filter by `Topic` +
`Question` to isolate an indicator (e.g. `Topic = 'Diabetes'`, `Question` containing
"prevalence"), and by `StratificationCategory1`/`Stratification1` to slice by demographic
group (Overall / Gender / Race-Ethnicity / Age). `LocationAbbr` is the 2-letter state code;
`US`, `GU`, `PR`, `VI` are national/territory rows and should usually be excluded from
state-level comparisons.
