Getting and Cleaning Data Project
=================================

Variables:
These are taken from the features.txt file. Only the mean ("-mean()") and standard deviation ("-std()") variables are retained.

Activities:
These are taken from activity\_labels.txt
  * 1 WALKING
  * 2 WALKING\_UPSTAIRS
  * 3 WALKING\_DOWNSTAIRS
  * 4 SITTING
  * 5 STANDING
  * 6 LAYING

From the test and train directories the following files are taken:
  * X\_xxxx.txt is the measurements file with one column for each variable in
  * features.txt and rows which correspond to the individual subjects and
  * specific activities via subject\_xxxx.txt and y\_xxxx.txt, respectively.

Transformations:
  * X\_xxxx.txt columns are removed to retain only the mean and standard
  * deviation columns.
