# Code Book
## Getting-and-Cleaning-Data Course Project

The script is tested on **Studio R Version 0.98.501. Google Chrome Version 35.0.1916.153 m**  (Windows NT 6.2; WOW64) 

The script [run_analysis.R] (https://github.com/mmoizuddin/Getting-and-Cleaning-Data/blob/master/run_analysis.R) must be copied in default working directory. 
The script will download the dataset zip file and unzip the file in directory "UCI HAR Dataset/"

### About Datasets
The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## How the Script Works
The script uses library: *data.table*

### Variables Used
  * fileUrl:        [downlaod link] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
  
  * getFeatures:         Load dataset from features.txt
  * meanstd_idx:         Filter the indices of mean and standard deviation from getFeatures by selecting variables that contain "mean" or "std"    
  * activityLabels:      Load dataset from ./activity_labels.txt
  * test_X:              Load dataset from ./test/X_test.txt    
  * labels_test_y:       Load dataset from ./test/y_test.txt
  * subject_test:        Load dataset from ./test/subject_test.txt
  * train_X:             Load dataset from ./train/X_train.txt     
  * labels_train_y:      Load dataset from ./train/y_train.txt 
  * subject_train:       Load dataset from ./train/subject_train.txt
  * placeholder_test_X:  Combine test datasets labels_test_y, subject_test and test_X
  * placeholder_train_X: Combine training datasets labels_train_y, subject_train and train_X
  * mergedDatasets:      Merge the two datasets placeholder_test_X and placeholder_train_X using rbind
  * datasetNames:        Used for making data tidy, fixing variables like punctuations and case adjustments 
  * tidyDataset:         A second dataset based on tidy data with two variables *Subject* (id of subject) and *Activity* (name of activity)
  
### The script does the following tasks: 
1. Merges the training and the test sets to create one data set.
  1.1  download link and save zip file "UCIHARDataset.zip" in current working dir
  1.2  unzip file and create dir "UCI HAR Dataset/"
  1.3  load features from *features.txt* dataset in the variables *getFeatures* and create indices for mean and std in *meanstd_idx*
  1.4  laod activity lables from *activity_labels.txt*
  1.5  load dataset for test in **test_X** from *./test/X_text.txt*
  1.6  load dataset for test labels in **labels_test_y** from *./test/y_test.txt*
  1.7  load dataset for test subjects in **subject_test** from *./test/subject_test.txt*
  1.8  load dataset for train in **train_X** from *./train/X_train.txt*
  1.9  load dataset for train labels in **labels_train_y** from *./train/y_train.txt*
  1.10 load dataset for train subjects in **subject_train** from *./train/subject_train.txt*
  1.11 combine labels_test_y, subject_test and test_X datasets in single dataset **placeholder_test_X** 
  1.12 combine labels_train_y, subject_train and train_X datasets in single dataset **placeholder_train_X** 
  1.13 merge placeholder_test_X and placeholder_train_X using rbind into **mergedDatasets**
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  2.1  subset **mergedDatasets** using indices create in point 1.3 " [,meanstd_idx$index] "
3. Uses descriptive activity names to name the activities in the data set
  3.1  factor the activities and assign the values to mergedDatasets$lables
4. Appropriately labels the data set with descriptive variable names. 
  4.1  making data tidy, fixing variables like punctuations and case adjustments 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  5.1 create second dataset based on tidy data with two variables *Subject* (id of subject) and *Activity* (name of activity)

Write tidy data sets to txt file in "UCI HAR Dataset" working dir 
