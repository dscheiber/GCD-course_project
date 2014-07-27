GCD-course_project
==================

For Coursera's Getting and Cleaning Data - Course Project:

run_analysis.R

*All files used for analyis belong to "Human Activity Recognition Using Smartphones Dataset - Version 1.0" found at URL, https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

* Experimental data gathered from ./train/X_train.txt, ./train/Y_train.txt, ./test/X_test.xt, and ./test/Y_test.txt.

* Labeling data gathered from features.txt and activity_labels.txt.

run_analysis.R takes experimental data from test set and training set and merges it together. The merged data is subsequently labeled with column names. Then "mean" and "std" (standard deviation) values are extracted from it and delivered to a new data set.

Using the new data set, the average is calculated per each experimental variable according to "Subjects" and "Labels" variables. The calculations are saved to a new tidy data frame. The subject and label is ultimately attached to the tidy data frame. The tidy data is then sorted for presentation and saved to both .csv and .txt files.

