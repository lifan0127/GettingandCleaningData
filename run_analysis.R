# Coursera - Getting and Cleaning Data Project
# Assignment:   Wearable computing data set clean-up
# Date:         4/26/2014

# Instruction:
# You should create one R script called run_analysis.R that does the following. 
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive activity names. 
# - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


# The following is my procedure:
# 1.  Some preparative work (create column names, labels etc.)
# 2.  Read x_train.txt into a dataframe train.x
# 3.  Read y_train.txt into a dtatframe train.y
# 4.  Read subject_train.txt into a dtatframe train.subject
# 5.  Perform cbind(train.x, train.y, train.subject)
# 6.  Repeat steps 2-5 with test data
# 7.  Combine train and test data into data.set
# 8.  Add "descriptive activity names" to data.set
# 9.  Extract all measurements on the mean and std
# 10. Compute grouped means using reshape library


library(reshape2)

# 1.  Some preparative work (create column names, labels etc.)
colnames <- read.table("UCIHARDataset/features.txt")[,2]
label <- read.table("UCIHARDataset/activity_labels.txt",
                    col.names=c("y", "label"))


# 2.  Read x_train.txt into a dataframe train.x
## Note: read.fwf(width=16) is more rigid for this data format. 
## However, read.fwf() is too slow and memory-demanding.
train.x <- read.table("UCIHARDataset/train/X_train.txt")
## If use the col.names arg in read.table, all special characters within 
## will be modified (ex. "tBodyAcc-mean()-X" --> "tBodyAcc.mean...X")
names(train.x) <- colnames


# 3.  Read y_train.txt into a dtatframe train.y
train.y <- read.table("UCIHARDataset/train/y_train.txt", 
                      col.names="y")


# 4.  Read subject_train.txt into a dtatframe train.subject
train.subject <- read.table("UCIHARDataset/train/subject_train.txt",
                            col.names="subject")


# 5.  Perform cbind(train.x, train.y, train.subject)
train <- cbind(train.y, train.subject, train.x)


# 6.  Repeat steps 2-5 with test data
test.x <- read.table("UCIHARDataset/test/X_test.txt")
names(test.x) <- colnames
test.y <- read.table("UCIHARDataset/test/y_test.txt", 
                      col.names="y")
test.subject <- read.table("UCIHARDataset/test/subject_test.txt",
                           col.names="subject")
test <- cbind(test.y, test.subject, test.x)


# 7.  Combine train and test data into data.set
data.set <- rbind(train, test)


# 8.  Add "descriptive activity names" to data.set
data.set <- merge(label, data.set, by="y")
## Remove column y which is no longer necessary
data.set <- data.set[, 2:ncol(data.set)]


# 9.  Extract all measurements on the mean and std
col.select <- grepl("mean\\(\\)|std\\(\\)", colnames)
selected <- data.set[, col.select]


# 10. Compute grouped means using reshape library
## use melt()/dcast() functions from reshape2 library
selected.melt <- melt(selected, id=c("label", "subject"))
avg.per.group <- dcast(selected.melt, label+subject~variable, mean)
#write.csv(avg.per.group, "UCIHARDataset/tidydata.csv")
write.table(avg.per.group, "UCIHARDataset/tidydata.txt")







