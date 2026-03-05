# Sugar Intake vs. Type 2 Diabetes Prevalence Across High-Income Nations
# Data sources:
#   Sugar: FAO Food Balance Sheets via OECD Health Statistics 2023 (g/capita/day)
#   Diabetes prevalence: IDF Diabetes Atlas 10th Edition (2021), adults 20-79 yrs
#   Country selection: OECD high-income nations with reliable data in both sources
#
# Copyright (c) 2026 Andrew R. Crocker. All rights reserved.

library(ggplot2)

# ── Data ──────────────────────────────────────────────────────────────────────
# Sugar figures represent total sugar & sweetener availability (g/capita/day),
# a standard proxy for consumption used in cross-national comparisons.
# Diabetes prevalence is age-standardised to national population (%).

countries <- data.frame(
  country = c(
    "United States", "Germany", "Netherlands", "Ireland", "Belgium",
    "United Kingdom", "Australia", "Canada", "France", "Sweden",
    "Denmark", "Norway", "Finland", "Switzerland", "Austria",
    "New Zealand", "Japan", "South Korea", "Italy", "Spain",
    "Portugal", "Greece", "Poland", "Czech Republic", "Hungary"
  ),
  sugar_g_day = c(
    126, 103, 103, 97, 95,
    93,  91,  89,  85, 84,
    84,  82,  80,  79, 95,
    88,  40,  49,  89, 85,
    91,  87,  98,  99, 100
  ),
  diabetes_pct = c(
    10.7, 8.3, 5.3, 4.4, 5.9,
    5.3,  5.1, 7.4, 6.0, 5.8,
    6.4,  4.7, 5.8, 5.8, 5.5,
    7.5,  7.4, 8.0, 5.6, 7.2,
    9.8,  7.5, 6.8, 7.2, 8.4
  ),
  # Flag the US as the rhetorical anchor point
  highlight = c(
    TRUE, rep(FALSE, 24)
  ),
  # Manual nudge to reduce label overlap
  nudge_x = c(
    -4,   2,  -2,  -3,   2,   # US, Germany, Netherlands, Ireland, Belgium
    -3,   2,  -3,   2,   2,   # UK, Australia, Canada, France, Sweden
    -3,  -3,  -3,  -3,  2,    # Denmark, Norway, Finland, Switzerland, Austria
     2,  -6,  -6,   2,  -3,   # NZ, Japan, S.Korea, Italy, Spain
     3,  -3,   2,   3,   2    # Portugal, Greece, Poland, Czech Rep, Hungary
  ),
  nudge_y = c(
     0.05,  0.15, -0.15,  0.15,  0.15,
    -0.15,  0.15, -0.15,  0.15,  0.15,
     0.15, -0.15,  0.15, -0.15,  0.15,
     0.15,  0.15, -0.15,  0.15, -0.15,
     0.15, -0.15,  0.15,  0.15, -0.15
  )
)

# ── Correlation (to cite inline or in caption) ────────────────────────────────
r_val <- round(cor(countries$sugar_g_day, countries$diabetes_pct), 2)
# r_val printed to console for reference
cat("Pearson r (sugar vs diabetes prevalence):", r_val, "\n")

# ── Plot ──────────────────────────────────────────────────────────────────────
theme_1950s <- function() {
  theme_minimal(base_family = "Arial", base_size = 14) +
    theme(
      plot.background = element_rect(fill = "#FAF5E9", color = NA),
      panel.background = element_rect(fill = "#FAF5E9", color = NA),
      panel.grid.major = element_line(color = "#E6DECA", linewidth = 0.6),
      panel.grid.minor = element_blank(),
      axis.title = element_text(face = "bold", color = "#3A3A3A"),
      axis.text = element_text(color = "#4A4A4A"),
      plot.title = element_text(face = "bold", size = 20, color = "#3A3A3A"),
      plot.subtitle = element_text(size = 13, color = "#5A5A5A"),
      plot.margin = margin(15, 15, 15, 15),
      legend.position = "none"
    )
}

p <- ggplot(countries, aes(x = sugar_g_day, y = diabetes_pct)) +
  # Regression line first (behind points)
  geom_smooth(
    method = "lm", se = TRUE,
    color = "#8B7355", fill = "#D4C5A9", alpha = 0.25, linewidth = 0.8
  ) +
  # All non-US points
  geom_point(
    data = subset(countries, !highlight),
    color = "#7A9E9F", size = 3.5, alpha = 0.85
  ) +
  # US point — distinct
  geom_point(
    data = subset(countries, highlight),
    color = "#C0392B", size = 5, shape = 18
  ) +
  # Labels with manual nudge offsets — applied row by row
  geom_text(
    data = countries,
    aes(
      x = sugar_g_day + nudge_x,
      y = diabetes_pct + nudge_y,
      label = country
    ),
    size = 3.2, color = "#3A3A3A", family = "Arial", hjust = 0.5
  ) +
  # Annotation: correlation coefficient
  annotate(
    "text",
    x = 125, y = 4.2,
    label = paste0("r = ", r_val),
    hjust = 1, size = 4.2, color = "#5A5A5A", family = "Arial",
    fontface = "italic"
  ) +
  scale_x_continuous(
    name = "Sugar availability (g/capita/day)",
    limits = c(30, 140),
    breaks = seq(40, 130, by = 20)
  ) +
  scale_y_continuous(
    name = "Diabetes prevalence, adults 20–79 (%)",
    limits = c(4, 11),
    breaks = seq(4, 11, by = 1)
  ) +
  labs(
    title = "More Sugar, More Diabetes? Not Exactly.",
    subtitle = paste0(
      "Sugar availability vs. diabetes prevalence across 25 high-income nations.\n",
      "If a single beverage were the problem, this cloud would be a line."
    ),
    caption = paste0(
      "Sources: FAO Food Balance Sheets via OECD Health Statistics (sugar, ~2020); ",
      "IDF Diabetes Atlas 10th ed. (diabetes prevalence, 2021).\n",
      "Sugar figures reflect total availability as a proxy for per-capita consumption. ",
      "Diabetes prevalence is age-standardised to national population."
    )
  ) +
  theme_1950s() +
  theme(
    plot.caption = element_text(
      size = 9, color = "#7A7A7A", lineheight = 1.3,
      margin = margin(t = 10)
    ),
    plot.subtitle = element_text(lineheight = 1.35)
  )

# ── Save ──────────────────────────────────────────────────────────────────────
output_dir <- file.path(path.expand("~"), "Documents", "sugar")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

output_path <- file.path(output_dir, "sugar_diabetes_scatter.png")

ggsave(
  filename = output_path,
  plot = p,
  width = 1456 / 96, height = 816 / 96, dpi = 96,
  bg = "#FAF5E9"
)

cat("Plot saved to:", output_path, "\n")
