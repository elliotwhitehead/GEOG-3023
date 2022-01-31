## GEOG3023 Statistics and Geographic Data
## Homework 2: Intro to R
## University of Colorado, Boulder
## Elliot Whitehead

install.packages("tidyverse")
library("ggplot2")
library(dplyr)

# Install Moments for Skewness
install.packages("moments")
library(moments)

# For Rolling Averages
# install.packages("zoo")
# library(zoo)

## What to submit: your R script (this file) and your plots (either as jpgs or copy and pasted into a word file)

## HINT: Use the "Introduction_to_R" file as the first place to look if you're not sure how to do something!

# The enclosed 'ColoradoCovidRecent.csv' file contains the basic covid statistics for the state of Colorado since September 1st, 2021
# The following is the description of each column:
# Date: each day of record
# DayNumber: Days since September 1st
# State: Colorado
# death: accumulative number of death till each day
# deathIncrease: new confirmed death on each day
# positive: accumulative number of positive cases till each day
# positiveIncrease: new confirmed positive cases on each day
# totalTestResults: accumulative number of test conducted till that day
# totalTestResultsIncrease: new tests on each day

# Here is the code to load the csv file
# Note, please first check where the file ColoradoCovidRecent.csv file located. 
# You may have to set your working directory to that location (where R looks for files by default)
# before opening the file (you can go to Tools -> GlobalOptions -> General to set the default working directory)
# OR you can set it with setwd() (see bottom of Introduction_to_R script)
covid = read.csv('lab_02/ColoradoCovidRecent.csv')

# Question 1 (25pts): Please find which date has:
# 1: the most increased death and 
index_of_max_deaths <- which.max(covid$deathIncrease)
cat("Date of greatest increase in deaths:", covid[index_of_max_deaths,]$Date)

# 2: which date has the most increased positive cases
index_of_max_pos_inc <- which.max(covid$positiveIncrease)
cat("Date of greatest increase in Positive Tests: ", covid[index_of_max_pos_inc,]$Date)

# 3: and which date has the most tests
index_of_max_tests <- which.max(covid$totalTestResultsIncrease)
print(index_of_max_tests)
cat("Date of greatest number of tests: ", covid[index_of_max_tests,]$Date)




# Question 2 (25pts): In the data frame 'covid', please add a new column called 'positivityRate' to show the daily positive rate (positiveIncrease/totalTestResultsIncrease)
positive_inc <- covid$positiveIncrease
total_test_results_inc <- covid$totalTestResultsIncrease

positivity_rate <- positive_inc / total_test_results_inc
covid["positivityRate"] <- positivity_rate


# Question 3 (25pts): Based on the variable you added in Question 2, please plot:
#(a) the daily positivity rate over time
#(b) the daily deaths over time (this isn't a new variable, it was already there)

# TODO: Pair labels and data with matching colors
# TODO: would be nice to average positivity rate across 7 days.


# ggplot() + geom_line(data=covid, aes(dayNumber, positivityRate)) + ggtitle("COVID Positivty Rate: Sep 01, 2021 to Jan 17, 2022") + xlab("Days Since Sep 1st, 2021") + ylab("Positivity Rate") + geom_line(data=covid, aes(dayNumber, covid$deathIncrease/36 ))

y_axis_scaling_factor <- 36

ggplot(covid, aes(x=dayNumber)) +
  geom_line(aes(y=deathIncrease / y_axis_scaling_factor), color="darkorange3", size=1.2) +
  geom_point(aes(y=positivity_rate), color="#3581B8") +
  xlab("Days Since Sep 1st, 2021") +
  scale_y_continuous(
    "Positivity Rate (%)",
    sec.axis = sec_axis(~ . * y_axis_scaling_factor, name="Daily Deaths")
  ) +
  theme(panel.background = element_rect(fill = "#EBE9E9")) +
  theme(axis.title.y = element_text(color="darkorange3", margin = margin(t = 0, r = 15, b = 0, l = 15))) +
  theme(axis.title.y.right = element_text(color="#3581B8", margin = margin(t = 0, r = 15, b = 0, l = 15))) +
  theme(axis.title.x = element_text(margin = margin(t=15, b=15)))


# Then, in the comments interpret the trends over the time

# As the data moves towards the holidays and into Winter, the number of daily 
# deaths increase, and generally so does the positivity rate.
# The highest recorded positivity rate occurred on January 08, after many
# people returned from Holiday travel and being at large gathering and crowded
# transportation hubs. following the increase in positivity rate is a noticeable
# uptick in the number of deaths reported daily, which is not surprising. 





# Question 4 (25pts): Make a histogram of the daily positivity rate
# Is the distribution left-skewed, right-skewed, or fairly symmetric? Answer in the comments

hist(covid$positivityRate, xlab="Positivity Rate", main="Histogram of Daily Positivity Rate")
cat("Daily Positivity Rate Skewness: ", skewness(covid$positivityRate))

# with a skewness value of 3.191539, the data are right-skewed. 



# End! Once you're done, make sure to save this script (File -> Save)
# Then you can copy and paste your plots into a word file or save them as image files 
# by clicking the "Export" button in the Plots pane
# On Canvas, you'll submit this file and your 4 plots:
# 1. Daily positivity rate over time
# 2. Daily deaths over time
# 3. Your histogram of the daily positivity rate