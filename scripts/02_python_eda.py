"""
Python EDA: healthcare coverage vs. obesity prevalence.
Reproduces the coverage/obesity scatter, trend, and regional-comparison analysis
described in the project report -- with the region-labeling bug fixed (see README).
"""
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_style("whitegrid")

# US Census Bureau regional grouping - used instead of the first 5 states alphabetically
REGION_MAP = {
    "CT":"Northeast","ME":"Northeast","MA":"Northeast","NH":"Northeast","RI":"Northeast","VT":"Northeast",
    "NJ":"Northeast","NY":"Northeast","PA":"Northeast",
    "IL":"Midwest","IN":"Midwest","MI":"Midwest","OH":"Midwest","WI":"Midwest","IA":"Midwest","KS":"Midwest",
    "MN":"Midwest","MO":"Midwest","NE":"Midwest","ND":"Midwest","SD":"Midwest",
    "DE":"South","FL":"South","GA":"South","MD":"South","NC":"South","SC":"South","VA":"South","DC":"South",
    "WV":"South","AL":"South","KY":"South","MS":"South","TN":"South","AR":"South","LA":"South","OK":"South","TX":"South",
    "AZ":"West","CO":"West","ID":"West","MT":"West","NV":"West","NM":"West","UT":"West","WY":"West",
    "AK":"West","CA":"West","HI":"West","OR":"West","WA":"West",
}

def load(path="data/cleaned/cdi_cleaned.csv"):
    df = pd.read_csv(path)
    df["region"] = df["LocationAbbr"].map(REGION_MAP)
    return df

def coverage_vs_obesity(df):
    cov = df[(df["Topic"]=="Health Status") & (df["Question"].str.contains("insurance", case=False, na=False))]
    cov = cov.groupby("LocationAbbr")["DataValueAlt"].mean().rename("coverage_pct")

    obesity = df[(df["Topic"]=="Nutrition, Physical Activity, and Weight Status") &
                 (df["Question"].str.contains("obesity", case=False, na=False))]
    obesity = obesity.groupby("LocationAbbr")["DataValueAlt"].mean().rename("obesity_pct")

    merged = pd.concat([cov, obesity], axis=1).dropna()
    merged["region"] = merged.index.map(REGION_MAP)

    plt.figure(figsize=(7,5))
    sns.regplot(data=merged, x="coverage_pct", y="obesity_pct", scatter_kws={"alpha":0.6})
    plt.title("Health Insurance Coverage vs. Obesity Prevalence (State-Level)")
    plt.xlabel("Current Coverage (%)"); plt.ylabel("Obesity Prevalence (%)")
    plt.tight_layout(); plt.savefig("visualizations/08_coverage_vs_obesity_rebuilt.png"); plt.close()

    region_avg = merged.groupby("region")["coverage_pct"].mean().sort_values(ascending=False)
    plt.figure(figsize=(7,5))
    region_avg.plot(kind="bar", color="#2e6f95")
    plt.title("Average Healthcare Coverage by Census Region (corrected)")
    plt.ylabel("Avg. Coverage (%)"); plt.xlabel("Region")
    plt.tight_layout(); plt.savefig("visualizations/10_coverage_by_region_corrected.png"); plt.close()

    return merged

if __name__ == "__main__":
    df = load()
    merged = coverage_vs_obesity(df)
    print(merged.groupby("region")[["coverage_pct","obesity_pct"]].mean())
