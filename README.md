Getting-and-Cleaning-Data
=========================
How to run the run_analysis.R

1. source("run_analysis.R")
2. df<-readData("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip")
3. meanStd<-setNames(onlyMeanStd(df))
4. newDataSet(meanStd)
