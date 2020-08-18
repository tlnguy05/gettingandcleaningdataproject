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
features <- fread("./UCI HAR Dataset/features.txt")

# Read the activity labels
# Only extract the 2nd column (the ID column is unnecessary)
activity_labels <- fread("./UCI HAR Dataset/activity_labels.txt")

# 1.Merges the training and the test sets to create one data set.
x_merge <- rbind(x_train, x_test)
y_merge <- rbind(y_train, y_test)
subject_merge <- rbind(subject_train, subject_test)
newdata <- cbind(x_merge, y_merge, subject_merge)

# 2.Extracts only the measurements on the mean and standard deviation for each 
# measurement.
# To match metacharacters in R, use a double backslash "\\"
mean_std_features <- grep(".*mean\\(\\)|std\\(\\)", features$V2)
x_merge <- x_merge[, ..mean_std_features] #Use ".." to extract columns in data table

# 3. Uses descriptive activity names to name the activities in the data set
y_merge$V1 <- factor(y_merge$V1, levels = activity_labels$V1, labels = activity_labels$V2)

# 4. Appropriately labels the data set with descriptive variable names.
colnames(x_merge) <- features$V2[mean_std_features]
colnames(y_merge) <- "activity"
colnames(subject_merge) <- "subject"

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
newdata <- cbind(x_merge, y_merge, subject_merge)
library(dplyr)
tidydata <- newdata %>% group_by(activity, subject) %>%
            summarise_all(funs(mean))
write.table(tidydata, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
