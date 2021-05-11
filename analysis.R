# Damita Gomez

# Analysis

# Set up - make sure to set your working directory using RStudio
library(tidyr)
library(dplyr)
library(ggplot2)

# Create the `charts/` directory (you can do this from R!)
dir.create("charts", showWarnings = FALSE)

# Load prepped data
data <- read.csv("data/prepped/all_data.csv")

# Are HALE and life expectancy correlated?
# - Plot 2016 life expectancy against 2016 HALE. Save the graph to `charts/`
# - Compute the correlation between 2016 life expectancy against 2016 HALE

# first, need to filter to just 2016 data
data_2016 <- data %>%
  filter(year == 2016)

png(file = "charts/le_vs_hale.png",
    width = 600, height = 350)

ggplot(data = data_2016) +
  geom_point(mapping = aes(x = le, y = hale))

dev.off()

# cor() computes the correlation coefficient
cor(data_2016$le, data_2016$hale)
# The answer is 0.9957015. Since this value is so high, it indicates a
# strong positive correlation between life expectancy and HALE, suggesting
# that as life expectancy increases, HALE can be expected to increase for a
# given country.


# Are HALE and DALYs correlated?
# - Plot 2016 HALE against 2016 DALYs. Save the graph to `charts/`
# - Compute the correlation between 2016 HALE and DALYs

png(file = "charts/hale_vs_dalys.png",
    width = 600, height = 350)

ggplot(data_2016) +
  geom_point(mapping = aes(x = hale, y = dalys))

dev.off()

cor(data_2016$hale, data_2016$dalys)
# The answer is -0.9859484. With this value, there is a strong negative
# correlation between HALE and DALYs, suggesting that as HALE increases,
# DALYs will decrease for a given country. This relationship makes sense
# based on the calculations for HALE and DALYs.

# As people live longer, do they live healthier lives
# (i.e., is a smaller fraction of life spent in poor health)?
# Follow the steps below to attempt to answer this question.

# First, you will need to reshape the data to create columns *by metric-year*
# This will create `hale_2016`, `hale_1990`, `le_2016`, etc.
# To do this, I suggest that you use the `pivot` function in the new
# tidyverse release:https://tidyr.tidyverse.org/articles/pivot.html#wider

# not sure if other years should be included or if this just applies to 2016
# data

# also, don't forget to use use variable name

data <- data %>%
  pivot_wider(names_from = year, values_from = c(hale, dalys, le))

# Create columns to store the change in life expectancy, and change in hale

data$hale_change <- abs(data$hale_1990 - data$hale_2016)

data$dalys_change <- abs(data$dalys_1990 - data$dalys_2016)

data$le_change <- abs(data$le_1990 - data$le_2016)

# Plot the *change in hale* against the *change in life expectancy*
# Add a 45 degree line (i.e., where x = y), and save the graph to `charts/`
# What does this mean?!?! Put your interpretation below

# data arguemnt might be different here depending on what happened above

png(file = "charts/hale_vs_le_change.png",
    width = 600, height = 350)

ggplot(data = data) +
  geom_point(mapping = aes(x = hale_change, y = le_change)) +
  geom_abline(intercept = 0, slope = 1)

dev.off()

# Interpretation here

# HALEs and Life Expectancy from 1990 to 2016 are not changing at an
# equal rate. It would appear that there is a greater difference in life
# expectancy for a given country between 1990 to 2016 than there is for
# health adjusted life expectancy. People are living longer in 2016 versus
# 1990, but that does not suggest that these are healthier years. As people
# live longer, the years that they live with a disability or disease also
# increases as seen by the fact that life expectancy and HALE are not
# increasing evenly.