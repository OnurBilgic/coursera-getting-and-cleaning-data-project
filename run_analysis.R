
rm(list=ls()) #clear history
library(reshape2)
foldername<-"getdata_dataset.zip" ##download folder

if (!file.exists(foldername)){
  file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file( file_url, foldername)
}  
if (!file.exists("UCI HAR Dataset")) {  ##unzip folder
  unzip(foldername) 
}
##import the files
features <- read.table("UCI HAR Dataset/features.txt",header=FALSE)
features$V2<-as.character(features$V2)
feature <- grep(".*mean.*|.*std.*", features$V2)
featuresnames <- features[feature,2]
featuresnames <- gsub('-mean', 'Mean', featuresnames)
featuresnames <- gsub('-std', 'Std', featuresnames)
featuresnames <- gsub('[-()]', '', featuresnames)
activitylabel  <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE)
colnames(activitylabel)  <- c('activity','activityname')
##import train files
trainsubject<- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
colnames(trainsubject) <-"subjectnumber"
trainx<- read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)
colnames(trainx)  <- featuresnames
trainy<- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)
colnames(trainy)  <- "activity"
train<-cbind(trainsubject, trainy, trainx)
##import test files
testsubject<-read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
colnames(testsubject) <-"subjectnumber"
testx<-read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE)
colnames(testx)  <- featuresnames
testy<-read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE)
colnames(testy)  <- "activity"
test<-cbind(testsubject, testy, testx)
## merge the datasets
alldata <- rbind(train, test)
alldata$activity <- factor(alldata$activity, levels = activitylabel$activity, labels = activitylabel$activityname)
alldata$subjectnumber <- as.factor(alldata$subjectnumber)
## summarize all data
alldatasummary <- melt(alldata, id = c("subjectnumber", "activity"))
alldata.summary <- dcast(alldatasummary, subjectnumber + activity ~ variable, mean)
write.table(alldata.summary, "tidy.txt", row.names = FALSE, quote = FALSE)