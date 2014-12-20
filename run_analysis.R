## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#load packages
library("plyr")

#dowload the dataset from internet, only the first time
if(file.exists("UCI HAR Dataset/") == FALSE){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="Dataset.zip", method="curl")
    unzip("Dataset.zip")
}

#read the dataset and create the dataframes
x_train<-read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
x_test<-read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
y_train<-read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
y_test<-read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)

#read other tables
features <- read.table("UCI HAR Dataset/features.txt")[,2]
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
meanstd_labels <- grepl("mean|std", features)

#Merges the training and the test sets to create one data set (x, y and subject).
x<-rbind(x_train, x_test)
y<-rbind(y_train, y_test)
subject<-rbind(subject_train, subject_test)

#rename cols
names(x) = features

#extract mean and standard deviation for each measurement
x = x[,meanstd_labels]

#rename the activities column entries
y[,1] = activity_labels[y[,1]]

#rename labels
colnames(y)<-"Activity_label"
colnames(subject)<-"Subject"

#merge x,y and subject in the final dataset
finalDataset<-cbind(x, y, subject)

#aggregate result of each variable for each activity and each subject
res<-ddply(finalDataset, c("Activity_label", "Subject"), numcolwise(mean))

#write the new tidy dataset
write.csv(res, "tidyDataset.csv", row.names=FALSE)




