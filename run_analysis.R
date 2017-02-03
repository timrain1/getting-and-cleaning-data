
library(plyr)
library(dplyr)
library(reshape2)

##read the datasets into R and appropriately labels the data set with descriptive variable names.
features<-read.table("features.txt",stringsAsFactors = FALSE)
setwd("./train")
y.train<-read.table("y_train.txt",col.names = "activityname")##reading the training labels and naming the variable
x.train<-read.table("x_train.txt")##reading the training set and naming the variables
subject.train<-read.table("subject_train.txt",col.names ="subjectnum" )##reading the subject label for training set and naming the variable.
setwd("../")
setwd("./test")
y.test<-read.table("y_test.txt",col.names = "activityname")##reading the test labels and naming the variable
x.test<-read.table("X_test.txt")##reading the test set and naming the variables
subject.test<-read.table("subject_test.txt",col.names ="subjectnum" )##reading the subject label for test set and naming the variable.
names(x.train)<-features[,2]##naming the variables
names(x.test)<-features[,2]##naming the variables
setwd("../")

##merge the data sets.
train<-cbind(y.train,subject.train,x.train)##merging the training data set.
test<-cbind(y.test,subject.test,x.test)##merging the testing data set.
mergedata<-rbind(train,test)##merging the testing and training data set.

##Extracts only the measurements on the mean and standard deviation for each measurement.
mergeclean<-mergedata[,grepl("mean|std|activityname|subjectnum",names(mergedata))]

##Uses descriptive activity names to name the activities in the data set
mergeclean$activityname=mapvalues(mergeclean$activityname,c(1,2,3,4,5,6),c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying"))

## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
x<-melt(mergeclean,id=c("activityname","subjectnum"),measure.vars = 3:81)##reshape the data so that we can use mean function on all variables.
tidydata<-dcast(x,activityname+subjectnum~variable,mean)##calculating the average of each variable for each activity and each subject.
write.table(tidydata,file = "tidydata.txt",row.names = FALSE)
View(tidydata)
