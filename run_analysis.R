# The goal is to prepare tidy data that can be used for later analysis
# Data for the project is available on
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# The R script called run_analysis.R does the following: 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#####################################################################################################################
library(data.table)

# STEP 1. Merges the training and the test sets to create one data set.
##

# Download Dataset
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,"UCIHARDataset.zip")
        unzip("UCIHARDataset.zip")
##

# Move to dir
        setwd("UCI HAR Dataset/")
##

# Get the features
        getFeatures <- read.table("features.txt", col.names = c("index", "name"))
        meanstd_idx <- subset(getFeatures, grepl("(mean|std)[(]", getFeatures$name))
##

# Get the labels
        activityLabels <- read.table("activity_labels.txt", col.names = c("index", "label"))
##

# get test data
        setwd("test/")
        test_X <- read.table("X_test.txt") 
        colnames(test_X) <- (meanstd_idx$name)
#
        labels_test_y <- read.table("y_test.txt")
        colnames(labels_test_y) <- "labels"
#
        subject_test <- read.table("subject_test.txt")
        colnames(subject_test) <- "subjects"
##

# get train data
        setwd("../train/")
        train_X  <- read.table("X_train.txt") 
        colnames(train_X) <- (meanstd_idx$name)
#
        labels_train_y <- read.table("y_train.txt")
        colnames(labels_train_y) <- "labels"
#
        subject_train <- read.table("subject_train.txt")
        colnames(subject_train) <- "subjects"
##

        subset_test_X   <- cbind(subject_test,  labels_test_y,  test_X )
        subset_train_X  <- cbind(subject_train, labels_train_y, train_X)
#
        mergedDatasets <- rbind(subset_test_X, subset_train_X)
        mergedDatasets <- mergedDatasets[order(mergedDatasets$subjects, mergedDatasets$labels),]
##
        setwd("..")
# <<< merge test and train data ends here >>>>
##


# STEP 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
        mergedDatasets <- mergedDatasets[,meanstd_idx$index]
# <<< filtering of mean and std ends here >>>>
##


# STEP 3. Uses descriptive activity names to name the activities in the data set
        mergedDatasets$labels  <- factor(activityLabels[mergedDatasets$labels, "label"])
# <<< applying description of activity to name ends here >>>>
##


# 4. Appropriately labels the data set with descriptive variable names.
        datasetNames <- names(mergedDatasets)
        datasetNames  <- gsub("[[:punct:]]", "", datasetNames )
        datasetNames  <- gsub("mean","Mean",datasetNames )
        datasetNames  <- gsub("std","Std",datasetNames )
        datasetNames  <- gsub("BodyBody", "Body", datasetNames ) 
        colnames(mergedDatasets) <- datasetNames 
# <<< labeling ends here >>>
##


# STEP 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
        tidyDataset <- aggregate(mergedDatasets[,3:ncol(mergedDatasets)],list(Subject=mergedDatasets$subjects, Activity=mergedDatasets$labels), mean)
# <<< Tidy Data created >>>
##

# Write tidy data sets to CSV file in "UCI HAR Dataset" working dir 
        write.csv(tidyDataset, file="UCIHARTidyDataset.csv", row.names=FALSE, quote = FALSE)
##