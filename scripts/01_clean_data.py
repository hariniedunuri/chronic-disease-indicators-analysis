"""
Cleans the raw CDC U.S. Chronic Disease Indicators (CDI) export.
Expects data/raw/chronic_disease_indicators.csv (34-column CDI schema).
"""
import pandas as pd

RAW_PATH = "data/raw/chronic_disease_indicators.csv"
OUT_PATH = "data/cleaned/cdi_cleaned.csv"

def main():
    df = pd.read_csv(RAW_PATH, low_memory=False)
    print("Raw shape:", df.shape)

    # DataValue ships as text (contains footnote markers); DataValueAlt is the numeric twin
    df["DataValueAlt"] = pd.to_numeric(df["DataValueAlt"], errors="coerce")
    df = df.dropna(subset=["DataValueAlt"])

    # keep the 50 states + DC, drop territories/national aggregate for state-level comparisons
    df = df[~df["LocationAbbr"].isin(["US", "GU", "PR", "VI"])]

    df["YearStart"] = df["YearStart"].astype(int)
    df["StratificationCategory1"] = df["StratificationCategory1"].fillna("Overall")
    df["Stratification1"] = df["Stratification1"].fillna("Overall")

    df.to_csv(OUT_PATH, index=False)
    print("Cleaned shape:", df.shape)
    print("Topics available:", df["Topic"].nunique())

if __name__ == "__main__":
    main()
