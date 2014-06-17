# Code Book
## Getting-and-Cleaning-Data Course Project

The script is tested on **Studio R Version 0.98.501. Google Chrome Version 35.0.1916.153 m**  (Windows NT 6.2; WOW64) 

The script [run_analysis.R] (https://github.com/mmoizuddin/Getting-and-Cleaning-Data/blob/master/run_analysis.R) must be copied in default working directory. 
The script will download the dataset zip file and unzip the file in directory "UCI HAR Dataset/"

### The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

### The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## How the Script Works
The script users library: *data.table*

### Variables Used
  fileUrl:        [downlaod link] ("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip") 
  
  getFeatures:    Read all values from features.txt
  meanstd_idx:    Filter the indices of mean and standard deviation from getFeatures by selecting variables that contain "mean" or "std"    activityLabels: 
  test_X:         
  labels_test_y:  
  subject_test:   
  train_X:         
  labels_train_y:  
  subject_train:  
  subset_test_X:  
  subset_train_X: 
  mergedDatasets: 
  datasetNames:   
  tidyDataset:    
  
  
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
        datasetNames  <- names(mergedDatasets)
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
        write.table(tidyDataset, file="UCIHARTidyDataset.txt", sep="\t", row.names=FALSE))
##
