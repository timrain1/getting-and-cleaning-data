
library(plyr)
library(dplyr)

##read the datasets into R and appropriately labels the data set with descriptive variable names.
features<-read.table("features.txt",stringsAsFactors = FALSE)
features<-features[,2]
setwd("./train")
y.train<-tbl_df(read.table("y_train.txt",col.names = "activityname"))##reading the training labels and naming the variable
x.train<-tbl_df(read.table("x_train.txt",col.names = features))##reading the training set and naming the variables
subject.train<-tbl_df(read.table("subject_train.txt",col.names ="subjectnum" ))##reading the subject label for training set and naming the variable.
setwd("../")
setwd("./test")
y.test<-tbl_df(read.table("y_test.txt",col.names = "activityname"))##reading the test labels and naming the variable
x.test<-tbl_df(read.table("X_test.txt",col.names = features))##reading the test set and naming the variables
subject.test<-tbl_df(read.table("subject_test.txt",col.names ="subjectnum" ))##reading the subject label for test set and naming the variable.
setwd("../")

##merge the data sets.
train<-tbl_df(cbind(y.train,subject.train,x.train))##merging the training data set.
test<-tbl_df(cbind(y.test,subject.test,x.test))##merging the testing data set.
mergedata<-tbl_df(rbind(train,test))##merging the testing and training data set.

##Extracts only the measurements on the mean and standard deviation for each measurement.
mergeclean<-mergedata[,grepl("mean|std|activityname|subjectnum",names(mergedata))]

##Uses descriptive activity names to name the activities in the data set
mergeclean$activityname=mapvalues(mergeclean$activityname,c(1,2,3,4,5,6),c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying"))

## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
x<-melt(mergeclean,id=c("activityname","subjectnum"),measure.vars = 3:81)##reshape the data so that we can use mean function on all variables.
tidydata<-dcast(x,activityname+subjectnum~variable,mean)##calculating the average of each variable for each activity and each subject.
write.table(tidydata,file = "tidydata.txt",row.names = FALSE)
View(tidydata)
