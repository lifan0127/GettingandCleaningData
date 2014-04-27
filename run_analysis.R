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
# 4.  Add "descriptive activity names" to train.y
# 5.  Read subject_train.txt into a dtatframe train.subject
# 6.  Perform cbind(train.x, train.y, train.subject)
# 7.  Repeat steps 2-6 with test data
# 8.  Combine train and test data into data.set
# 9.  Extract the measurements on the mean and std
# 10. Compute the average of each variable for each activity
# 11. Compute the average of each variable for each subject


# 1.  Some preparative work (create column names, labels etc.)
colnames <- read.table("UCIHARDataset/features.txt")[,2]
label <- read.table("UCIHARDataset/activity_labels.txt",
                    col.names=c("y", "label"))
subject <- 1:30


# 2.  Read x_train.txt into a dataframe train.x
## Note: read.fwf(width=16) is more rigid for this data format. 
## However, read.fwf() is too slow and memory-demanding.
train.x <- read.table("UCIHARDataset/train/X_train.txt",
                      col.names=colnames)


# 3.  Read y_train.txt into a dtatframe train.y
train.y <- read.table("UCIHARDataset/train/y_train.txt", 
                      col.names="y")


# 4.  Add "descriptive activity names" to train.y
train.y <- merge(train.y, label, by="y")


# 5.  Read subject_train.txt into a dtatframe train.subject
train.subject <- read.table("UCIHARDataset/train/subject_train.txt",
                            col.names="subject")

# 6.  Perform cbind(train.x, train.y, train.subject)
train <- cbind(train.x, label=train.y[,2], train.subject)


# 7.  Repeat steps 2-6 with test data
test.x <- read.table("UCIHARDataset/test/X_test.txt",
                      col.names=colnames)
test.y <- read.table("UCIHARDataset/test/y_test.txt", 
                      col.names="y")
test.y <- merge(test.y, label, by="y")
test.subject <- read.table("UCIHARDataset/test/subject_test.txt",
                           col.names="subject")
test <- cbind(test.x, label=test.y[,2], test.subject)


# 8.  Combine train and test data into data.set
data.set <- rbind(train, test)


# 9.  Extract the measurements on the mean and std
col.select <- grepl("mean\\(\\)|std\\(\\)", colnames)
selected <- data.set[, col.select]


# 10. Build an expanded dataframe for all label/subject combinations
## Concatenate label(activity) /subject and store in a new column
selected$interaction <- paste(selected$label, selected$subject, sep=".")

## Construct all combinations of labels(activity) and subjects.
interact <- as.data.frame(c(outer(label[[2]], subject, paste, sep=".")))
names(interact) <- "interaction"

## Merge the two dataframes
expanded <- merge(selected, interact, by="interaction", all=TRUE)


# 11. Fix the column name issue
## Note: Colnames (variable names) have been modified by R.
## (ex. "tBodyAcc-mean()-X" --> "tBodyAcc.mean...X")
## Create a vector for the new variable names.
var.names <- names(selected)
## Remove label, subject and interaction columns
var.names <- var.names[1:(length(var.names)-3)] 


# 12. Compute the variable averages per activity and subject
grouped.avg <- data.frame(numeric(nrow(interact)))
for (var in var.names){
  #message(paste0("Grouped avaerges for ", var))
  avg <- tapply(expanded[, var], expanded[, "interaction"], mean)
  grouped.avg[, var] <- avg
}
grouped.avg <- grouped.avg[, 2:ncol(grouped.avg)]
write.csv(grouped.avg, "UCIHARDataset/GroupedAverage.csv")









