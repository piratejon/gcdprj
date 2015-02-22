
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

## these two help us quickly load the large X_test and X_train files
require(LaF)
require(ffbase)

uciFolder <- 'UCI HAR Dataset'

fetchPath <- function(whichFile, testOrTrain) {
  if (whichFile == 'activity_labels' || whichFile == 'features') {
    sprintf('%s/%s.txt', uciFolder, whichFile)
  } else {
    sprintf("%s/%s/%s_%s.txt", uciFolder, testOrTrain, whichFile, testOrTrain)
  }
}

consume_space_sep_file <- function(whichFile) {
  read.csv(fetchPath(whichFile), sep=' ', header=FALSE, stringsAsFactors=FALSE)
}

selectFeatureVariables <- function(featureTable) {
# we want the mean and standard deviation variables
# these are the ones that end with mean() and std()
# we do not want the meanFreq() variable
  varList <- grepl("mean", featureTable$V2)
  varList = varList | grepl("std", featureTable$V2)
  varList = varList & !(featureTable$V1 %in% grep("meanFreq", featureTable$V2))
  varList
}

consume_X <- function(testOrTrain) {
#read.fwf(fetchPath('X', testOrTrain), widths=rep(16, 561))
  as.data.frame(
      laf_to_ffdf(
        laf_open_fwf(
          fetchPath('X', testOrTrain),
          column_widths=rep(16,561),
          column_types=rep('double', 561)
          )
        )
      )
}

consume_column_file <- function(whichFile, testOrTrain) {
  read.table(fetchPath(whichFile, testOrTrain))
}

consume_data <- function(whichFile, whichSet) {
  if (whichFile == 'X') {
    consume_X(whichSet)
  } else if (whichFile == 'y' || whichFile == 'subject') {
    consume_column_file(whichFile, whichSet)
  } else if (whichFile == 'activity_labels' || whichFile == 'features') {
    consume_space_sep_file(whichFile)
  } else {
    warning(sprintf("no file %s", whichFile))
  }
}

get_feature_labels <- function() {
  all_features <- consume_data('features')
  mean_std_features <- all_features[selectFeatureVariables(all_features),]
  names(mean_std_features) <- c('id', 'name')
  mean_std_features
}

join_all_the_data <- function() {
  # load the activity labels
  actlab <- consume_data('activity_labels')
  names(actlab) <- c('id', 'label')
  actlab$label <- as.factor(actlab$label)

  # load the feature labels
  mean_std_features <- get_feature_labels()

  # load and name the test data
  x_test <- consume_data('X', 'test')[,mean_std_features$id]
  names(x_test) <- mean_std_features$name
  y_test <- consume_data('y', 'test')
  names(y_test) <- 'activity_id'
  s_test <- consume_data('subject', 'test')
  names(s_test) <- 'subject_id'
  s_test$subject_id <- as.factor(s_test$subject_id)

  # load and name the train data
  x_train <- consume_data('X', 'train')[,mean_std_features$id]
  names(x_train) <- mean_std_features$name
  y_train <- consume_data('y', 'train')
  names(y_train) <- 'activity_id'
  s_train <- consume_data('subject', 'train')
  names(s_train) <- 'subject_id'
  s_train$subject_id <- as.factor(s_train$subject_id)

  # replace the y lists with factor labels
  y_test <- as.data.frame(merge(y_test, actlab, by.x='activity_id', by.y='id', sort=FALSE)$label)
  names(y_test) <- 'activity'
  y_train <- as.data.frame(merge(y_train, actlab, by.x='activity_id', by.y='id', sort=FALSE)$label)
  names(y_train) <- 'activity'

  # join the measurements, activity and subject factors
  test_set <- cbind(x_test, y_test, s_test)
  train_set <- cbind(x_train, y_train, s_train)

  # merge the test and trial sets
  # -- factoring them is not required by the assignment but could be useful down the line
  test_set$set <- as.factor('test')
  train_set$set <- as.factor('train')

  rbind(test_set, train_set)
}

mean_by_subject_and_activity <- function(df) {
  result <- expand.grid(levels(df$activity), levels(df$subject_id))
  features <- get_feature_labels()

  all_means <- as.data.frame(lapply(
    features$name, function(f) {
      apply(result, 1, function(x) {
          mean(
              subset(
                df, activity==x[[1]] & subject_id==x[[2]], select=f
                )[[f]]
              )
          }
          )
      }
      )
      )

  names(result) <- c("activity", "subject_id")
  names(all_means) <- features$name
  rbind(result, all_means)
}

main <- function() {
  tidy <- join_all_the_data()
  write.table(tidy, file='tidy.txt', sep='\t', row.name=FALSE)
  all_means <- mean_by_subject_and_activity(tidy)
  write.table(all_means, file='tidy2.txt', sep='\t', row.name=FALSE)
}

