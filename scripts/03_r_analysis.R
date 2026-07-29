# R analysis: socioeconomic status vs. obesity/diabetes prevalence
# Reproduces the ggplot2 visualizations in visualizations/01-05
# (Gini index vs diabetes, education vs obesity, obesity/diabetes distributions and trends)

library(tidyverse)

cdi <- read_csv("data/cleaned/cdi_cleaned.csv")

diabetes <- cdi %>%
  filter(Topic == "Diabetes", str_detect(Question, regex("prevalence", ignore_case = TRUE))) %>%
  group_by(LocationAbbr, YearStart) %>%
  summarise(diabetes_pct = mean(DataValueAlt, na.rm = TRUE), .groups = "drop")

obesity <- cdi %>%
  filter(Topic == "Nutrition, Physical Activity, and Weight Status",
         str_detect(Question, regex("obesity", ignore_case = TRUE))) %>%
  group_by(LocationAbbr, YearStart) %>%
  summarise(obesity_pct = mean(DataValueAlt, na.rm = TRUE), .groups = "drop")

trend <- diabetes %>%
  inner_join(obesity, by = c("LocationAbbr","YearStart")) %>%
  group_by(YearStart) %>%
  summarise(avg_diabetes = mean(diabetes_pct), avg_obesity = mean(obesity_pct))

ggplot(trend, aes(x = YearStart)) +
  geom_line(aes(y = avg_diabetes, color = "Diabetes")) +
  geom_line(aes(y = avg_obesity, color = "Obesity")) +
  labs(title = "Trends of Obesity and Diabetes Prevalence Over Time",
       x = "Year", y = "Prevalence (%)", color = "Condition") +
  theme_minimal()
ggsave("visualizations/02_obesity_diabetes_trends_rebuilt.png", width = 8, height = 5)

ggplot(obesity, aes(x = obesity_pct)) +
  geom_histogram(bins = 20, fill = "#4472C4") +
  labs(title = "Distribution of Obesity Prevalence", x = "Obesity Prevalence (%)", y = "Count") +
  theme_minimal()
ggsave("visualizations/04_obesity_distribution_rebuilt.png", width = 7, height = 5)
