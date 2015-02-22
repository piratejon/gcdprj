
###
### Required Steps:
### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive variable names. 
### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###
### Notes:
### This script is assumed to have the same parent directory as the "UCI HAR Dataset" directory.

uciFolder <- 'UCI HAR Dataset'

fetchPatch <- function(whichFile, testOrTrain) {
  if (whichFile == 'activity_labels' || whichFile == 'features') {
    sprintf('%s/%s.txt', uciFolder, whichFile)
  } else {
    sprintf("%s/%s/%s_%s.txt", uciFolder, testOrTrain, whichFile, testOrTrain)
  }
}

consumeFeatureFile <- function() {
  read.csv(fetchPath("features"), sep=' ', header=FALSE, stringsAsFactors=FALSE)
}

consumeActivityFile <- function() {
  read.csv(fetchPath('activity_labels'), sep=' ', header=FALSE, stringsAsFactors=FALSE)
}

selectFeatureVariables <- function() {
# we want the mean and standard deviation variables
# these are the ones that end with mean() and std()
# we do not want the meanFreq() variable
  featureTable <- consumeFeatureFile()
  varList <- grepl("mean", featureTable$V2)
  varList = varList | grepl("std", featureTable$V2)
  varList = varList & !(featureTable$V1 %in% grep("meanFreq", featureTable$V2))
  varList
}

consume_X <- function(testOrTrain) {
  read.fwf(fetchPath('X', testOrTrain), widths=rep(16, 561))
}

consume_column_file <- function(whichFile, testOrTrain) {
  read.table(fetchPatch(whichFile, testOrTrain))
}

consume_data <- function(whichFile, whichSet) {
  if (whichFile == 'X') consume_X(whichSet)
  else if (whichFile == 'y' || whichFile == 'subject') consume_column_file(whichFile, whichSet)
  warning(sprintf("no file %s", whichFile))
}

