# Download and unzip the UCI HAR Dataset
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_url, destfile = "dataset.zip", method = "curl")
unzip("dataset.zip")

# Install the "data.table" package to make use of the fread() function,
# that helps reading the large dataset faster
install.packages("data.table")
library(data.table)

# Read the train data from UCI HAR Dataset.
x_train <- fread("./UCI HAR Dataset/train/X_train.txt")
y_train <- fread("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- fread("./UCI HAR Dataset/train/subject_train.txt")

# Read the train data from UCI HAR Dataset.
x_test <- fread("./UCI HAR Dataset/test/X_test.txt")
y_test <- fread("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- fread("./UCI HAR Dataset/test/subject_test.txt")

# Read the feature description
# Only extract the 2nd column (the ID column is unnecessary)
features <- fread("./UCI HAR Dataset/features.txt", select = 2)

# Read the activity labels
# Only extract the 2nd column (the ID column is unnecessary)
activity_labels <- fread("./UCI HAR Dataset/activity_labels.txt")

# 1.Merges the training and the test sets to create one data set.
