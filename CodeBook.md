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

1.  Some preparative work (create column names, labels etc.)

2.  Read x_train.txt into a dataframe train.x

3.  Read y_train.txt into a dtatframe train.y

4.  Read subject_train.txt into a dtatframe train.subject

5.  Perform cbind(train.x, train.y, train.subject)

6.  Repeat steps 2-5 with test data

7.  Combine train and test data into data.set

8.  Add "descriptive activity names" to data.set

9.  Extract all measurements on the mean and std

10. Compute grouped means using reshape library


Below are more detailed explanations:

* 1.  Some preparative work (create column names, labels etc.)

Because the main data files are in txt format with no headers, the first step was to obtain those information from other files:
Column names (variables) were obtained from features.txt using read.table() and stored in dataframe "colnames".
Labels (activities) were obtained from activity_label.txt similarly and stored in "label".

* 2.  Read x_train.txt into a dataframe "train.x"

Based on the file structure, it appeared read.fwf(width=16) was the most suitable approach to import the data. However, in practice read.fwf() behaved unbearably slow and consumed too much memory.
Instead, read.table() was used and subsequently the column names from step 1 were assigned.

Note that if the column names were assigned using the col.names argument in read.table(), all special characters in column names will be removed (ex. "tBodyAcc-mean()-X" --> "tBodyAcc.mean...X").

* 3.  Read y_train.txt into a dtatframe train.y

Data in y_train.txt was imported into dataframe "train.y". Note it only contains the number representation which will be converted into more descriptive name in step 8.

* 4.  Read subject_train.txt into a dtatframe train.subject

Read train subject (experiment volunteers) information from the subject_train.txt file.

* 5.  Perform cbind(train.x, train.y, train.subject)

Combined train.y and train.subject and train.x into a single data.frame "train" using cbind().

* 6.  Repeat steps 2-5 with test data

Repeated steps 2-5 for test data and saved into dataframe "test" accordingly.

* 7.  Combine train and test data into data.set

Used rbind() to cobmine train and test data into dataframe "data.set".

* 8.  Add "descriptive activity names" to data.set

Using the merge(label, data.set, by="y") function, descriptive names were added into data frame train.y. As a result, the y column is no longer necessary and removed from the dataframe.

Note that merge should not be performed prior to all cbind() operations, because the merged dataframe lost its order.

* 9.  Extract all measurements on the mean and std

Upon visual examination of the data, it was found that the required variables all contain "mean()" in their names. Therefore, regular expression grepl() was used to locate their positions, and the returned logical vector was then used to select those rows and stored them in dataframe "selected".
It should be noted that some variables also contain "mean" in their names (ex. meanFreq). It was necessary to include the parentheses () to exclude those terms. The parentheses () also needs to be properly escaped ("mean\\(\\)|std\\(\\)"). 

* 10. Compute grouped means using reshape library

Thanks to the reshape2 library, the variable averages per activity per subject were easily computed via melt() and dcast() functions.

Finally, the tidy data set was exported into a txt file "tidydata.txt".




























