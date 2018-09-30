
library(dplyr)

### READ DATA

# read train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read features
features<- read.table("./UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")


### MERGE DATA

#1 merge the training and the test sets
X_complete <- rbind(X_train, X_test)
Y_complete<- rbind(Y_train, Y_test)
subject_complete <- rbind(subject_train, subject_test)


### MEASUREMENT EXTRACTION & LABELING

#2 extract only the measurements on the mean and standard deviation for each measurement.
selected_var <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_complete <- X_complete[,selected_var[,1]]

#3 uses descriptive activity names to name the activities in the data set
colnames(Y_complete) <- "activity"
Y_complete$activitylabel <- factor(Y_complete$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_complete[,-1]

#4 appropriately label the data set with descriptive variable names.
colnames(X_complete) <- features[selected_var[,1],2]

### SECOND DATA SET

#5 create a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(subject_complete) <- "subject"
complete <- cbind(X_complete, activitylabel, subject_complete)
complete_mean <- complete %>% group_by(activitylabel, subject) %>% summarise_each(funs(mean))
write.table(complete_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)