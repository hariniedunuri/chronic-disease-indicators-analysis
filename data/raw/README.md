# Raw Data

Not committed to this repo (large, publicly re-downloadable).

**Source:** CDC "U.S. Chronic Disease Indicators (CDI)" — https://data.cdc.gov (search
"U.S. Chronic Disease Indicators"), also mirrored on data.gov and Kaggle.

**To reproduce:**
1. Download the full CSV export and place it at `data/raw/chronic_disease_indicators.csv`.
2. Run `scripts/01_clean_data.py`.
3. Run the SQL in `sql/` against any relational database (schema in `sql/01_create_table.sql`),
   `scripts/02_python_eda.py` for the coverage/obesity analysis, and `scripts/03_r_analysis.R`
   for the socioeconomic-status analysis.

Schema reference: [`documentation/schema_notes.md`](../documentation/schema_notes.md).
