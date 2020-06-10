# datacleaning
Course repo for Coursera Getting and Cleaning Data course

This repo contains a single R script, run_analysis.R in the main directory.  This script defines a function run_analysis() which accepts a single optional parameter providing the directory containing the raw data files.  If the parameter is not specified, the working directory is used to access the raw data files.These files define raw and derived time-series sensor readings from the Samsung S accelerometer readings, plus categorical data specifying user activities taking place at for each data point.

The function extracts from the full data set the columns corresponding to mean and standard deviation of sensor readings over a window of time around the data point.  Measures from the raw data not corresponding to mean or std are ignored.  These extracted data are then categorized according to the activity the user is performing at the time corresonding to the data point.  

Finally, the data points are categorized by activity, with average value for each extracted sensor reading associated with activity and measure.  A tidy data set is returned three columns: 

* activity, 
* measure and 
* value

Each combination of activity and mean- or standard-deviation- measure from the full data set is represented by a unique row in the resulting data table.  The value in each row is the average of all values for the specified measure observed while the activity was being performed across all subjects and trials.
