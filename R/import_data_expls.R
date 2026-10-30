# here::i_am() states where this script lives *relative to the project root*
# (the folder containing Recap-02.Rproj). From that, here() finds the root
# on any computer, whatever the current working directory is.
here::i_am("R/import_data_expls.R")
library(here)
library(tidyverse)

# here() builds the path starting from the project root, so this line works
# no matter whether the script is run from R/, from the root, or rendered
# inside a Quarto document in text/. here("data", "raw", "airquality.csv")
# is equivalent.
air_data <- read_csv(file = here("data/raw/airquality.csv"))
head(air_data)
