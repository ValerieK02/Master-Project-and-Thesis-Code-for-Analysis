# THE FOLLOWING CODE IS USED FOR DATA MANAGMENT AND IT HELPS ORGNIZE THE RAW OUTPUT FILES FROM KALEIDOSCOPE

# Install packages for fuctions I need (e.g. tell R to read an output)
# The following comments tell R to call up the installed packages

library(tidyverse)
library(ggplot2)
library(dplyr)
library(suncalc)
library(lubridate)

# To install something use the following command and change the thing in the ""install.packages("ggplot2")
# install.packages("ggplot2")
# I installed all of the packages in the console

# Name the data frame (unmodified) => I want to tell R to read my raw data

kpro_raw <- read_csv("data/cm_2025_total.csv")

# Checking if the data has NA or missed columns
str(kpro_raw) 
summary(kpro_raw) 
summary(kpro_raw$autoid) 
colSums(is.na(kpro_raw))

na_rows <- kpro_raw %>% filter(is.na(DATE))

#choose variables for data set
kpro_raw <- kpro_raw %>% # =>  this tells R to modifiy the actual table instead of making copies of it each time something is changed
  rename(
    filename = "OUT_FILE_FS") %>% # this command just renames one of the columns and then after that it can be mentioned in the code below as a column that should be kept
  mutate(autoid = factor(autoid)) %>% 
  dplyr::select(OUTDIR, FOLDER, IN_FILE, filename, DURATION, 
                DATE, TIME, HOUR,
                DATE_12, TIME_12, HOUR_12,
                autoid, PULSES, MATCHING, MATCH_RATIO, ALTERNATE_1, ALTERNATE_2, Site
  )

# The command below will put the new/modified table onto my computer
write.csv(kpro_raw, "kpro_raw_summary.csv")
