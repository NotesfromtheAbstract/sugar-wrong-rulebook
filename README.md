# The Wrong Rulebook: Sugar, Diabetes, and the Limits of Kennedy's Argument

Supporting data and code for the *Notes from the Abstract* article "The Wrong Rulebook," published March 2026.

## What This Repository Contains

**sugar_diabetes_scatter.R** — R script that generates the scatter plot of sugar availability per capita against type 2 diabetes prevalence across 25 high-income nations. Requires ggplot2. No external data files needed; all values are hardcoded from published sources cited below.

**sugar_diabetes_scatter.png** — The rendered chart at Substack publication dimensions (1456x816px).

## Data Sources

Sugar availability figures represent total sugar and sweetener availability in grams per capita per day, drawn from FAO Food Balance Sheets as compiled in OECD Health Statistics (~2020). These figures reflect food supply availability and serve as a standard cross-national proxy for consumption.

Diabetes prevalence estimates are age-standardized to national population for adults aged 20–79 years, drawn from the IDF Diabetes Atlas 10th Edition (2021).

Full citation: Sun H, Saeedi P, Karuranga S, et al. IDF Diabetes Atlas: Global, regional and country-level diabetes prevalence estimates for 2021 and projections for 2045. *Diabetes Res Clin Pract.* 2022;183:109119.

## Key Finding

Pearson r = 0.15 across 25 high-income nations, meaning sugar availability explains approximately two percent of the variation in diabetes prevalence. The scatter plot shows no meaningful linear relationship between country-level sugar consumption and diabetes outcomes, which is inconsistent with a single-product, single-exposure causal model.

## Usage

```r
# Requires ggplot2
# theme_1950s() must be defined in your environment before running
# The script includes the theme definition

Rscript sugar_diabetes_scatter.R
```

Output saves to `~/Documents/sugar/sugar_diabetes_scatter.png` by default. Modify the `output_dir` variable at the bottom of the script to change the destination.

## License

Copyright (c) 2026 Andrew R. Crocker. All rights reserved. See LICENSE for terms.
