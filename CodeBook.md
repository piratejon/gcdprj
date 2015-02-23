Getting and Cleaning Data Project
=================================

Variables:
These are taken from the features.txt file. Only the mean ("-mean()") and standard deviation ("-std()") variables are retained.

Activities:
These are taken from activity\_labels.txt. They are presented in the data as factors with labels that make sense so it is not necessary to look up a numeric meaning in the codebook.
  * 1 WALKING
  * 2 WALKING\_UPSTAIRS
  * 3 WALKING\_DOWNSTAIRS
  * 4 SITTING
  * 5 STANDING
  * 6 LAYING

Subject IDs:
These are also taken from the source data (y\_xxxx.txt).

From the test and train directories the following files are taken:
  * X\_xxxx.txt is the measurements file with one column for each variable in
  * features.txt and rows which correspond to the individual subjects and
  * specific activities via subject\_xxxx.txt and y\_xxxx.txt, respectively.

Transformations:
  * X\_xxxx.txt columns are removed to retain only the mean and standard deviation columns
  * y\_xxxx.txt columns show which activity the measurement corresponds to
  * subject\_xxxx.txt defines which subject performed the activity that was measured.

The y\_xxxx.txt file indexes the activity\_labels.txt file to find the name and this is stored as a factor. subject labels are just numbers and do not have a name but these are also stored in the data frame as factors. The X\_xxxx.txt files do not have column names and these are taken from the features.txt file which is filtered to include only "-mean()" and "-std()" columns per the requirements. The y\_xxxx activity factors and subject\_xxxx subject factors are joined to the column-labeled X\_xxxx measurements and the resulting dataframe completes step 4. For step 5, a mean is computed for each combination of subject, activity factor, and variable name. The subjects and activity factors define the rows in the final tidy dataframe, and the columns are the means of the corresponding variables for the subject and activity factors.
