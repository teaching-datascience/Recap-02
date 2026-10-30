here::i_am("R/data_wrangling.R")
library(here)
library(tidyverse)

# Long vs. wide data
#
# Long (tidy) format: every variable is a column, every observation a row.
#   This is what ggplot2 and most tidyverse functions expect.
# Wide format: the values of one variable (e.g. day, year, country) are
#   spread over several columns. Handy for tables meant to be read by humans,
#   and common in data as you download it (e.g. one column per year).
#
# pivot_wider():  long -> wide
# pivot_longer(): wide -> long

# Example 1: airquality ----

# airquality is already long: one row per day.
air_data <- read_csv(file = here("data/raw/airquality.csv"))
head(air_data)

# Wide: one row per month, one column per day of the month.
#   names_from:  the column whose values become the new column names
#   values_from: the column whose values fill the new columns
wider_data <- air_data |>
  select(c("Temp", "Day", "Month")) |>
  pivot_wider(
    names_from = "Day",
    values_from = "Temp")
wider_data

# For the plot we need the long version: Day, Temp and Month must each be a
# single column so they can be mapped to x, y and colour.
air_data_plot <- ggplot(
  data = air_data,
  mapping = aes(x = Day, y = Temp, color = as_factor(Month))) +
  geom_point() +
  geom_line() +
  scale_color_viridis_d() +
  theme_minimal()
air_data_plot

# Example 2: gapminder ----

gapminder_data <- gapminder::gapminder
head(gapminder_data)

# Wide: one row per country, one column per year.
wider_data_2 <- gapminder_data |>
  filter(country %in% c("Germany", "Denmark")) |>  # same as: country == "Germany" | country == "Denmark"
  select(c("country", "gdpPercap", "year")) |>     # same as: select(-c("continent", "lifeExp", "pop"))
  pivot_wider(names_from = "year", values_from = "gdpPercap")
wider_data_2

# Back to long: the year columns are collapsed into two columns.
#   cols:      the columns to collapse (here: all except country)
#   names_to:  name of the new column holding the old column names
#   values_to: name of the new column holding the values
# Note: the new year column is of type character, since it was made from
# column names.
longer_data_2 <- wider_data_2 |>
  pivot_longer(
    cols = -"country",
    names_to = "year",
    values_to = "gdpPercap")
longer_data_2

# The same, but selecting the columns to collapse by their names.
longer_data_2 <- wider_data_2 |>
  pivot_longer(
    cols = c(
      starts_with("19"),
      starts_with("20")),
    names_to = "year",
    values_to = "gdpPercap")
longer_data_2

# Check: names_from decides what becomes the columns. Here: one column per
# country, one row per year.
wider_data_3 <- gapminder_data |>
  filter(country %in% c("Germany", "Denmark")) |>
  select(c("country", "gdpPercap", "year")) |>
  pivot_wider(names_from = "country", values_from = "gdpPercap")
wider_data_3
