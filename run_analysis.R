#read the data
getData<-function(url, file)
{
      library(utils)      
      file<-download.file(url, destfile=file, method="curl")
      unzip(file)
}
#1. Merge test and train datasets
readData<-function()
{
        
     
      features<-read.table("UCI HAR Dataset/features.txt")
      trainSubject <-read.table("UCI HAR Dataset/train/subject_train.txt", sep="", col.names=c("subjectID"))     
      train<-read.table("UCI HAR Dataset/train/X_train.txt", sep="", col.names=features[,2])
      trainLabels<-read.table("UCI HAR Dataset/train/Y_train.txt", sep="", col.names="activityID")
      
      #merging data
      trainData <-cbind(trainLabels,trainSubject,train)
      
      testSubject <-read.table("UCI HAR Dataset/test/subject_test.txt", sep="", col.names=c("subjectID"))     
      test<-read.table("UCI HAR Dataset/test/X_test.txt", sep="", col.names=features[,2])
      testLabels<-read.table("UCI HAR Dataset/test/Y_test.txt", sep="", col.names="activityID")
      
      #merging data
      testData <-cbind(testLabels,testSubject,test)
      allData  <-rbind(trainData,testData)  
     
      allData
}
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
onlyMeanStd<-function(data)
{
      names<-colnames(data)
      onlyMeanStd <- data.frame(data[,c("activityID","subjectID",subset(colnames(data),grepl("Mean|std", names)))])
      onlyMeanStd
}
#3.Uses descriptive activity names to name the activities in the data set
descriptiveActv<-function(datastd)
{
      library(plyr)
      activity <-read.table("UCI HAR Dataset/activity_labels.txt",sep="",col.names=c("activityID", "activityType"))
      datastd$activityName <- join(datastd, activity, by = "activityID", match = "first")
      datastd$activityName
}
#4.Appropriately labels the data set with descriptive names.

setNames<-function(tidyData)
{
      namesData<-names(tidyData)
      namesData <- gsub("*Acc*", "Accelerator", namesData)
      namesData <- gsub("Mag", "Magnitude", namesData)
      namesData <- gsub("*Gyro*", "Gyroscope", namesData)
      namesData <- gsub("-std$","StdDev",namesData)
      namesData <-  gsub("-mean","Mean",namesData)
      namesData <- gsub("^t", "time", namesData)
      namesData <- gsub("^f", "frequency", namesData)
      namesData <- gsub("JerkMag","JerkMagnitude",namesData)
      namesData <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",namesData)
      colnames(tidyData)<-namesData
      tidyData
}
#5.From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.
newDataSet<-function(data)
{
      avg<-ddply(data, c("subjectID","activityID"), numcolwise(mean))
      write.table(avg, file = "avg.txt", row.name=FALSE)
}

