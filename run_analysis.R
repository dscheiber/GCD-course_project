library(plyr)
##features
  ##column names for data sets, each 'feature' is a measurement
features <- read.table("features.txt", stringsAsFactors=F)[,2]

##activity labels
  ##names for activity, e.g. walking, standing
labels <- read.table("activity_labels.txt", stringsAsFactors=F)[,2]
  ##function to convert activity from numeric to 'label'
labeler <- function(x){
  x <- labels[x]
}

##/train/
  ##combines all the training data into one data frame
trainingSet <- read.table("train/X_train.txt")
trainingSet$Labels <- read.table("train/Y_train.txt")[,1]
  ##converts numeric to 'label'
trainingSet$Labels <- sapply(trainingSet$Labels, labeler)
trainingSet$Subjects <- read.table("train/subject_train.txt")[,1]
  ##add ID to trainingSet to help merge 
trainingSet$ID <- seq(nrow(trainingSet))

##/test/
  ##combines all the test data into one data frame
testSet <- read.table("test/X_test.txt")
testSet$Labels <- read.table("test/Y_test.txt")[,1]
##converts numeric to 'label'
testSet$Labels <- sapply(testSet$Labels, labeler)
testSet$Subjects <- read.table("test/subject_test.txt")[,1]
  ##add ID to testSet to help merge 
testSet$ID <- seq(nrow(testSet))+nrow(trainingSet)

##merged frame
  ##combines trainingSet and testSet using given ID
mergedFrame <- join(testSet, trainingSet, by="ID", type="full")
colnames(mergedFrame) <- c(features, "Labels", "Subjects", "ID")
colnames(mergedFrame) <- gsub("meanFreq", "mFreq", names(mergedFrame))

##extract row of mean and standard deviation data
  ## mean

#meanFreqRows <- gsub("meanFreq", "mFreq", names(mergedFrame))
meanRows <- grep("mean", names(mergedFrame))

 ##standard deviation
stdRows <- grep("std", names(mergedFrame))

  ##extracted data: mean, std, labels, subjects
extractedSet <- mergedFrame[,c(meanRows, stdRows)] ; extractedSet$Labels <- mergedFrame$Labels ; extractedSet$Subjects <- mergedFrame$Subjects

##new tidy dataframe ###################
  ##data set with average of each variable for each activity and each subject

##for loop for tidy data
  ##loop through subjects and labels
  ## trims data set to only data that has specified label and subject
  ## calculates average for non-label & subject variables, adds to tidy data frame
  ## stores label and subject in other data frame to be added to final frame later
tD.rowNames <- ''
tD.finalFrame <- data.frame()
holdingFrame <- data.frame(a=1:180)
counter <- 1
for (i in unique(extractedSet$Subjects)){
  for (j in 1:length(unique(extractedSet$Labels))){
    tD.rowNames <- c(tD.rowNames, toString(c(i,unique(extractedSet$Labels)[j])))
    workingSet <- extractedSet[(extractedSet$Labels==unique(extractedSet$Labels)[j] & extractedSet$Subjects==i), ][,1:66]
    averages <- sapply(workingSet, mean)
    tD.finalFrame <- rbind(averages, tD.finalFrame)
    holdingFrame$Labels[counter] <- unique(extractedSet$Labels)[j]
    holdingFrame$Subjects[counter] <- unique(extractedSet$Subjects)[i]
    counter <- counter + 1
    
  }
}

##adds labels and subjects to tidy data frame and adds column names
tD.finalFrame$Labels <- holdingFrame$Labels
tD.finalFrame$Subjects <- holdingFrame$Subjects
colnames(tD.finalFrame) <- names(extractedSet)[1:68]

##orders the columns for easier interperetation 
tD.finalFrame <- tD.finalFrame[, c(68, 67, 1:66)]
tD.finalFrame <- tD.finalFrame[order(tD.finalFrame$Subjects),]

##outputs tidy data to to csv and txt
write.csv(tD.finalFrame, file="samsung-averages.csv")
write.table(tD.finalFrame, file="samsung-averages.txt")