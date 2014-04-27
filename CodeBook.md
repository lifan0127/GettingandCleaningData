## Coursera - Getting and Cleaning Data Project
Assignment:   Wearable computing data set clean-up
Date:         4/27/2014

#### Introduction:

This is a data cleaning project for a Coursera MOOC - Getting and Cleaning Data. 
class.coursera.org/getdata-002
The data set comes from the following reference:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


#### The dataset includes the following files 

(Note: excerpt from README.txt):
* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 



#### Introduction of features/variables:

(Note: excerpt from README.txt):
These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'UCIHARDataset/features.txt'



#### Procedures for data cleanup

The following procedure was performed to produce the tidy dataset:
# Some preparative work (create column names, labels etc.)
# Read x_train.txt into a dataframe train.x
# Read y_train.txt into a dtatframe train.y
# Add "descriptive activity names" to train.y
# Read subject_train.txt into a dtatframe train.subject
# Perform cbind(train.x, train.y, train.subject)
# Repeat steps 2-6 with test data
# Combine train and test data into data.set
# Extract the measurements on the mean and std
# Build an expanded dataframe for all label/subject combinations
# Fix the column name issue
# Compute the variable averages per activity and subject

Below are more detailed explanations:
# Some preparative work (create column names, labels etc.)
Because the main data files are in txt format with no headers, the first step was to obtain those information from other files:
Column names (variables) were obtained from features.txt using read.table() and stored in dataframe "colnames".
Labels (activities) were obtained from activity_label.txt similarly and stored in "label".
Subject ("subject") was created using a simple vector of 1:30 which are the codes to represent each volunteer in this experiment.

# Read x_train.txt into a dataframe "train.x"
Based on the file structure, it seems read.fwf(width=16) is the most suitable approach to import the data. However, in practice read.fwf() behaved unbearably slow and consumed too much memory.
Instead, read.table() was used and the column names from step 1 were assigned at the same time.

# Read y_train.txt into a dtatframe "train.y"
Data in y_train.txt was imported into dataframe "train.y". Note it only contains the number representation which will be converted into more descriptive name in the next step.

# Add "descriptive activity names" to "train.y"
Using the merge(train.y, label, by="y") function, descriptive names were added into data frame train.y

# Read subject_train.txt into a dtatframe train.subject
Obtained train subject (experiment volunteers) information from the subject_train.txt file.

# Perform cbind(train.x, train.y, train.subject)
Combined train.x, train.y and train.subject into a single data.frame "train" using cbind().

# Repeat steps 2-6 with test data
Repeated steps 2-6 for test data "test".

# Combine train and test data into "data.set"
Used rbind() to cobmine train and test data into dataframe "data.set".

# Extract the measurements on the mean and std
Upon visual examination of the data, it was found that the required variables all contain "mean()" in their names. Therefore, regular expression grepl() was used to locate their positions, and the returned logical vector was then used to select those rows and stored them in dataframe "selected".
It should be noted that some variables also contain "mean" in their names (ex. meanFreq). It was necessary to include the parentheses () to exclude those terms. The parentheses () also needs to be properly escaped ("mean\\(\\)|std\\(\\)"). 

# Build an expanded dataframe for all label/subject combinations
Using the table() function (table(selected$label, selected$subject)), it was observed that not all subjects (experiment volunteers) participated in all the activities. To compute a dataframe with all 30 subjects * 6 activities = 180 combinations, it was needed to expand the dataframe to include those missing combinations before applying a map function to compute the grouped means.
All 180 combinations were computed using the outer product outer() function and stored in a dataframe "interact".
Meanwhile, an extra column was added to dataframe "select" to store the concatenation of subject and activity for each observations.
Next, the "interact" and "select" dataframes were merged (with by="interaction and all=TRUE) to obtain the expanded dataframe "expanded" that included all combinations missed in the original "select" dataframe.

# Fix the column name issue
A minor issue was found that the column names was silently modified by R to comply with its naming ruling. The modified names were again extracted back from the dataframe "selected" to be used in the next step.

# Compute the variable averages per activity and subject
The tapply() function could be used to conveniently apply a function to a vector grouped by another vector. Here, a for loop was used to iterate through all variables. Within each loop, the tapply() function was then applied to compute the grouped average for that variable. Finally, all average data was stored in a dataframe "grouped.avg".
After the for loop, the data frame was exported into a csv or txt and submitted to Coursera for grading.

It may be possible to not use the for loop, which will be investigated later.





























